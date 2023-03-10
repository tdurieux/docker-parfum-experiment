# This Docker file is used to build an ubuntu image with the necessary
# packages installed to complete an xReg build (along with its dependencies)

ARG os_version=16.04

FROM ubuntu:${os_version}

RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
      ca-certificates \
      cmake \
      wget \
      libssl-dev \
      git \
      libglew-dev \
      libxt-dev && \
    rm -rf /var/lib/apt/lists/*

# Build a recent version of cmake
RUN mkdir cmake_build && cd cmake_build && \
    wget https://github.com/Kitware/CMake/releases/download/v3.18.2/cmake-3.18.2.tar.gz && \
    tar xf cmake-3.18.2.tar.gz && cd cmake-3.18.2 && mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && cmake --build . && cmake --build . --target install && \
    cd / && rm -rf cmake_build && rm cmake-3.18.2.tar.gz

