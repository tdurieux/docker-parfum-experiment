FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

ARG PYTHON_VERSION=3.6
ARG INSTALL_DEPS_EXTRA_ARGS

ADD scripts /tmp/scripts
RUN /tmp/scripts/install_ubuntu.sh -p $PYTHON_VERSION && \
    /tmp/scripts/install_os_deps.sh -d gpu $INSTALL_DEPS_EXTRA_ARGS && \
    /tmp/scripts/install_python_deps.sh -p $PYTHON_VERSION -d gpu $INSTALL_DEPS_EXTRA_ARGS && \
    rm -rf /tmp/scripts

WORKDIR /root

# Allow configure to pick up GDK and CuDNN where it expects it.
# (Note: $CUDNN_VERSION is defined by NVidia's base image)
RUN _CUDNN_VERSION=$(echo $CUDNN_VERSION | cut -d. -f1-2) && \
    mkdir -p /usr/local/cudnn-$_CUDNN_VERSION/cuda/include && \
    ln -s /usr/include/cudnn.h /usr/local/cudnn-$_CUDNN_VERSION/cuda/include/cudnn.h && \
    mkdir -p /usr/local/cudnn-$_CUDNN_VERSION/cuda/lib64 && \
    ln -s /etc/alternatives/libcudnn_so /usr/local/cudnn-$_CUDNN_VERSION/cuda/lib64/libcudnn.so && \
    ln -s /usr/local/cudnn{-$_CUDNN_VERSION,}

ENV LD_LIBRARY_PATH /usr/local/openblas/lib:$LD_LIBRARY_PATH

ARG BUILD_USER=onnxruntimedev
ARG BUILD_UID=1000
RUN adduser --gecos 'onnxruntime Build User' --disabled-password $BUILD_USER --uid $BUILD_UID
WORKDIR /home/$BUILD_USER
USER $BUILD_USER