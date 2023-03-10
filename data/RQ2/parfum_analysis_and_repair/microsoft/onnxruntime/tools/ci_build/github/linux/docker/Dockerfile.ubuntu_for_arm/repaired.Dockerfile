ARG OS_VERSION=20.04
FROM ubuntu:${OS_VERSION}

ARG PYTHON_VERSION=3.8
ADD scripts /tmp/scripts
RUN /tmp/scripts/install_ubuntu.sh -p $PYTHON_VERSION -d EdgeDevice && \
    /tmp/scripts/install_os_deps.sh -d EdgeDevice && \
    /tmp/scripts/install_python_deps.sh -p $PYTHON_VERSION -d EdgeDevice && \
    /tmp/scripts/install_protobuf.sh

ARG TOOL_CHAIN="fsl-imx-xwayland-glibc-x86_64-fsl-image-qt5-aarch64-toolchain-4.19-warrior.sh"
RUN /tmp/scripts/$TOOL_CHAIN -y  && rm -rf /tmp/scripts

ARG BUILD_UID=1000
ARG BUILD_USER=onnxruntimedev
RUN adduser --gecos 'onnxruntime Build User' --disabled-password $BUILD_USER --uid $BUILD_UID
WORKDIR /home/$BUILD_USER
USER $BUILD_USER