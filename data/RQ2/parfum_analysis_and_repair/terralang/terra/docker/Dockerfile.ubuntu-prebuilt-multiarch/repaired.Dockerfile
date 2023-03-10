ARG release=18.04

FROM ubuntu:$release

ARG arch=x86_64
ARG llvm=6.0
ARG threads=4

ENV DEBIAN_FRONTEND noninteractive
ENV CI 1 # skip CUDA tests

COPY . /terra

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends -qq build-essential cmake git python3 wget && \
    wget -nv https://github.com/terralang/llvm-build/releases/download/llvm-$llvm/clang+llvm-$llvm-$arch-linux-gnu.tar.xz && \
    tar xf clang+llvm-$llvm-$arch-linux-gnu.tar.xz && \
    mv clang+llvm-$llvm-$arch-linux-gnu /llvm && \
    rm clang+llvm-$llvm-$arch-linux-gnu.tar.xz && \
    echo "disabled: /terra/docker/install_cuda.sh" && \
    cd /terra/build && \
    cmake -DCMAKE_PREFIX_PATH=/llvm/install -DCMAKE_INSTALL_PREFIX=/terra_install .. && \
    make install -j$threads && \
    echo "disabled: ctest --output-on-failure -j$threads" && rm -rf /var/lib/apt/lists/*;
