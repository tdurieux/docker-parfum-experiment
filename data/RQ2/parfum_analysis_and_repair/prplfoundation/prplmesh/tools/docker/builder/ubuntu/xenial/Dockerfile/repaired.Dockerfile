FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y \
    autoconf \
    autogen \
    binutils \
    clang-format \
    cmake \
    curl \
    gcc \
    git \
    libjson-c-dev \
    libncurses-dev \
    libnl-3-dev \
    libnl-route-3-dev \
    libnl-genl-3-dev \
    libreadline-dev \
    libssl-dev \
    libtool \
    ninja-build \
    pkg-config \
    python \
    python-yaml \
    python3 \
    python3-yaml \
    uuid-runtime \
    vim \
    && rm -rf /var/lib/apt/lists/*
