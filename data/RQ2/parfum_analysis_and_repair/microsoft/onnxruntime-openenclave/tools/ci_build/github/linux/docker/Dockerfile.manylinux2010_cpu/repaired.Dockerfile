FROM quay.io/pypa/manylinux2010_x86_64:2020-04-04-f427f46

ARG PYTHON_VERSION
ADD scripts /tmp/scripts
RUN cd /tmp/scripts && /tmp/scripts/install_centos.sh && /tmp/scripts/install_deps.sh -p $PYTHON_VERSION && rm -rf /tmp/scripts

ARG BUILD_UID=1000
ARG BUILD_USER=onnxruntimedev
RUN adduser --uid $BUILD_UID $BUILD_USER 
WORKDIR /home/$BUILD_USER
USER $BUILD_USER