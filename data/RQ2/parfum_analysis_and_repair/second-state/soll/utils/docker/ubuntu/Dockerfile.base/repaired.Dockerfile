FROM ubuntu:20.04

RUN apt update \
    && apt install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN apt update \
    && apt install --no-install-recommends -y \
        llvm-10-dev \
        llvm-10-tools \
        liblld-10-dev \
        cmake \
        make \
        wget \
        python3-psutil \
        binaryen && rm -rf /var/lib/apt/lists/*;

RUN rm -rf /var/lib/apt/lists/*
