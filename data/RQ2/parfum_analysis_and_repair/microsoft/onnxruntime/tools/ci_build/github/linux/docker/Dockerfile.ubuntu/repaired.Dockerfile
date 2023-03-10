FROM ubuntu:20.04

ARG PYTHON_VERSION=3.8

ADD scripts /tmp/scripts
RUN /tmp/scripts/install_ubuntu.sh -p $PYTHON_VERSION && /tmp/scripts/install_os_deps.sh && /tmp/scripts/install_python_deps.sh -p $PYTHON_VERSION && rm -rf /tmp/scripts

WORKDIR /root

ARG BUILD_UID=1000
ARG BUILD_USER=onnxruntimedev
RUN adduser --gecos 'onnxruntime Build User' --disabled-password $BUILD_USER --uid $BUILD_UID
WORKDIR /home/$BUILD_USER
USER $BUILD_USER