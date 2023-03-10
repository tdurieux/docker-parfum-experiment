FROM rocm/pytorch:rocm4.1.1_centos7_py3.6_pytorch

#Build manylinux2014 docker image begin
ENV AUDITWHEEL_ARCH x86_64
ENV AUDITWHEEL_PLAT manylinux2014_$AUDITWHEEL_ARCH
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV DEVTOOLSET_ROOTPATH /opt/rh/devtoolset-8/root
ENV PATH $DEVTOOLSET_ROOTPATH/usr/bin:$PATH
ENV LD_LIBRARY_PATH $DEVTOOLSET_ROOTPATH/usr/lib64:$DEVTOOLSET_ROOTPATH/usr/lib:$DEVTOOLSET_ROOTPATH/usr/lib64/dyninst:$DEVTOOLSET_ROOTPATH/usr/lib/dyninst:/usr/local/lib64:/usr/local/lib
ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig

COPY manylinux2014_build_scripts /manylinux2014_build_scripts
RUN bash /manylinux2014_build_scripts/build.sh 8 && rm -r /manylinux2014_build_scripts 

ENV SSL_CERT_FILE=/opt/_internal/certs.pem

#Build manylinux2014 docker image end

ARG PYTHON_VERSION=3.6
ARG INSTALL_DEPS_EXTRA_ARGS

#Add our own dependencies
ADD scripts /tmp/scripts
RUN cd /tmp/scripts && \
    /tmp/scripts/install_centos.sh && \
    /tmp/scripts/install_os_deps.sh -d gpu $INSTALL_DEPS_EXTRA_ARGS && \
    /tmp/scripts/install_python_deps.sh -d gpu -p $PYTHON_VERSION $INSTALL_DEPS_EXTRA_ARGS && \
    rm -rf /tmp/scripts

ARG BUILD_UID=1001
ARG BUILD_USER=onnxruntimedev
RUN adduser --uid $BUILD_UID $BUILD_USER
WORKDIR /home/$BUILD_USER
USER $BUILD_USER
ENV PATH /usr/local/gradle/bin:/usr/local/dotnet:$PATH