FROM quay.io/pypa/manylinux2014_x86_64:latest

ADD scripts /tmp/scripts
RUN cd /tmp/scripts && /tmp/scripts/manylinux/install_centos.sh && /tmp/scripts/manylinux/install_deps_aten.sh && rm -rf /tmp/scripts

ARG BUILD_UID=1001
ARG BUILD_USER=onnxruntimedev
RUN adduser --uid $BUILD_UID $BUILD_USER
WORKDIR /home/$BUILD_USER
USER $BUILD_USER