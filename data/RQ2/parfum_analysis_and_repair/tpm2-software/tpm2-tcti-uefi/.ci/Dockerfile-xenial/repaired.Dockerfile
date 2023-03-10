FROM ubuntu:xenial AS build

ARG PREFIX=/usr

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
    autoconf \
    automake \
    bc \
    build-essential \
    cpio \
    iasl \
    expect \
    flex \
    gawk \
    git \
    gnulib \
    lcov \
    libcmocka-dev \
    libglib2.0-dev \
    libpixman-1-dev \
    libssl-dev \
    libtasn1-dev \
    libtool \
    nasm \
    net-tools \
    pkg-config \
    python3 \
    rpm2cpio \
    socat \
    sudo \
    uuid-dev \
    wget && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp/build-deps
COPY ./.ci/build-deps.sh ./
COPY ./.ci/target-ovmf-debug-x64-gcc.txt ./
COPY ./.ci/tss2-sys_config.site ./
RUN bash -x ./build-deps.sh --prefix=${PREFIX} \
    --edk2-target=$(pwd)/target-ovmf-debug-x64-gcc.txt \
    --tss2-config-site=$(pwd)/tss2-sys_config.site
