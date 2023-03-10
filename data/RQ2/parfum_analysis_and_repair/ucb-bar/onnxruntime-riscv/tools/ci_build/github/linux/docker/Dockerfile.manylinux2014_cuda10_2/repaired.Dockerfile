FROM nvcr.io/nvidia/cuda:10.2-cudnn8-devel-centos7

#We need both CUDA and manylinux. But the CUDA Toolkit End User License Agreement says NVIDIA CUDA Driver Libraries(libcuda.so, libnvidia-ptxjitcompiler.so) are only distributable in applications that meet this criteria:
#1. The application was developed starting from a NVIDIA CUDA container obtained from Docker Hub or the NVIDIA GPU Cloud, and
#2. The resulting application is packaged as a Docker container and distributed to users on Docker Hub or the NVIDIA GPU Cloud only.
#So we use CUDA as the base image then add manylinux on top of it.

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
RUN bash /manylinux2014_build_scripts/build.sh 8 && rm -r manylinux2014_build_scripts && yum downgrade  -y glibc-2.17-317.el7 glibc-common-2.17-317.el7 glibc-devel-2.17-317.el7 glibc-headers-2.17-317.el7

ENV SSL_CERT_FILE=/opt/_internal/certs.pem

#Build manylinux2014 docker image end

#Add our own dependencies
ADD scripts /tmp/scripts
RUN cd /tmp/scripts && /tmp/scripts/manylinux/install_centos.sh && /tmp/scripts/manylinux/install_deps.sh && rm -rf /tmp/scripts

ARG BUILD_UID=1001
ARG BUILD_USER=onnxruntimedev
RUN adduser --uid $BUILD_UID $BUILD_USER
WORKDIR /home/$BUILD_USER
USER $BUILD_USER
ENV PATH /usr/local/gradle/bin:/usr/local/dotnet:$PATH