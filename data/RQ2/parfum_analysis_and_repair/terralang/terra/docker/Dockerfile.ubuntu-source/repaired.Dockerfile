ARG release=18.04

FROM ubuntu:$release

ARG llvm=6.0
ARG threads=4

ENV DEBIAN_FRONTEND noninteractive
ENV CI 1 # skip CUDA tests

COPY . /terra

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends -qq build-essential cmake git python3 wget && \
    mkdir /llvm && \
    cd /llvm && \
    wget -nv https://releases.llvm.org/$llvm/llvm-$llvm.src.tar.xz && \
    wget -nv https://releases.llvm.org/$llvm/cfe-$llvm.src.tar.xz && \
    tar xf llvm-$llvm.src.tar.xz && \
    tar xf cfe-$llvm.src.tar.xz && \
    mv cfe-$llvm.src llvm-$llvm.src/tools/clang && \
    mkdir build install && \
    cd build && \
    cmake ../llvm-$llvm.src -DCMAKE_INSTALL_PREFIX=$PWD/../install -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_TERMINFO=OFF -DLLVM_ENABLE_LIBEDIT=OFF -DLLVM_ENABLE_ZLIB=OFF -DLLVM_ENABLE_LIBXML2=OFF -DLLVM_ENABLE_ASSERTIONS=OFF && \
    make install -j$threads && \
    cd .. && \
    rm -rf llvm-$llvm.src* cfe-$llvm.src* build && \
    cd /terra/build && \
    cmake -DCMAKE_PREFIX_PATH=/llvm/install -DCMAKE_INSTALL_PREFIX=/terra_install .. && \
    make install -j$threads && \
    ctest --output-on-failure -j$threads && rm llvm-$llvm.src.tar.xz && rm -rf /var/lib/apt/lists/*;
