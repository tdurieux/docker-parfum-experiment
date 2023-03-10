ARG release=18.04

FROM ubuntu:$release

ARG llvm=6.0
ARG threads=4

ENV DEBIAN_FRONTEND noninteractive
ENV CI 1 # skip CUDA tests

COPY . /terra

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends -qq build-essential cmake git llvm-$llvm-dev libclang-$llvm-dev clang-$llvm libedit-dev libncurses5-dev zlib1g-dev libpfm4-dev && \
    cd /terra/build && \
    cmake -DCMAKE_INSTALL_PREFIX=/terra_install .. && \
    make install -j$threads && \
    ctest --output-on-failure -j$threads && rm -rf /var/lib/apt/lists/*;
