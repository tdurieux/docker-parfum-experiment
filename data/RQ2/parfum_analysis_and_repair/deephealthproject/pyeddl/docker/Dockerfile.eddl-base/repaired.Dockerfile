FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu18.04

ARG cmake_v=3.21.3
ARG eigen_v=3.3.7
ARG proto_v=3.11.4

RUN apt-get -y update && apt-get -y install --no-install-recommends \
      wget \
      zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN wget -q https://github.com/Kitware/CMake/releases/download/v${cmake_v}/cmake-${cmake_v}-linux-x86_64.sh && \
    chmod u+x cmake-${cmake_v}-linux-x86_64.sh && \
    ./cmake-${cmake_v}-linux-x86_64.sh --skip-license --prefix=/usr/local && \
    rm -f cmake-${cmake_v}-linux-x86_64.sh

# Eigen version installed by APT is too old to work properly with CUDA
# https://devtalk.nvidia.com/default/topic/1026622/nvcc-can-t-compile-code-that-uses-eigen/
RUN wget -q https://gitlab.com/libeigen/eigen/-/archive/${eigen_v}/eigen-${eigen_v}.tar.gz && \
    tar xf eigen-${eigen_v}.tar.gz && \
    cd eigen-${eigen_v} && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make install && rm eigen-${eigen_v}.tar.gz
ENV CPATH="/usr/local/include/eigen3:${CPATH}"

RUN wget -q https://github.com/protocolbuffers/protobuf/releases/download/v${proto_v}/protobuf-all-${proto_v}.tar.gz && \
    tar xf protobuf-all-${proto_v}.tar.gz && \
    cd protobuf-${proto_v}/ && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make -j$(nproc) && \
    make install && \
    ldconfig && rm protobuf-all-${proto_v}.tar.gz
