# Tag: nvidia/cuda:10.0-cudnn7-devel-ubuntu16.04
# Label: com.nvidia.cuda.version: 10.0.130
# Label: com.nvidia.cudnn.version: 7.3.1.20
# Ubuntu 16.04.5
FROM nvidia/cuda@sha256:362e4e25aa46a18dfa834360140e91b61cdb0a3a2796c8e09dadb268b9de3f6b

ARG PYTHON_VERSION=3.5

ADD scripts /tmp/scripts
RUN /tmp/scripts/install_ubuntu.sh -p ${PYTHON_VERSION} && /tmp/scripts/install_deps.sh && rm -rf /tmp/scripts

WORKDIR /root

# Allow configure to pick up GDK and CuDNN where it expects it.
# (Note: $CUDNN_VERSION is defined by NVidia's base image)
RUN _CUDNN_VERSION=$(echo $CUDNN_VERSION | cut -d. -f1-2) && \
    mkdir -p /usr/local/cudnn-$_CUDNN_VERSION/cuda/include && \
    ln -s /usr/include/cudnn.h /usr/local/cudnn-$_CUDNN_VERSION/cuda/include/cudnn.h && \
    mkdir -p /usr/local/cudnn-$_CUDNN_VERSION/cuda/lib64 && \
    ln -s /etc/alternatives/libcudnn_so /usr/local/cudnn-$_CUDNN_VERSION/cuda/lib64/libcudnn.so && \
    ln -s /usr/local/cudnn{-$_CUDNN_VERSION,}

# Build and Install LLVM
ARG LLVM_VERSION=6.0.1
RUN cd /tmp && \
    wget --no-verbose http://releases.llvm.org/$LLVM_VERSION/llvm-$LLVM_VERSION.src.tar.xz && \
    xz -d llvm-$LLVM_VERSION.src.tar.xz && \
    tar xvf llvm-$LLVM_VERSION.src.tar && \
    cd llvm-$LLVM_VERSION.src && \
    mkdir -p build && \
    cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    cmake --build . -- -j$(nproc) && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local/llvm-$LLVM_VERSION -DBUILD_TYPE=Release -P cmake_install.cmake && \
    cd /tmp && \
    rm -rf llvm*

ENV LD_LIBRARY_PATH /usr/local/openblas/lib:$LD_LIBRARY_PATH

ARG BUILD_USER=onnxruntimedev
ARG BUILD_UID=1000
WORKDIR /home/$BUILD_USER
RUN adduser --gecos 'onnxruntime Build User' --disabled-password $BUILD_USER --uid $BUILD_UID
USER $BUILD_USER

