FROM ubuntu:16.04 AS base

RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-pil python3-setuptools python3-dev build-essential git wget tar libusb-1.0-0.dev libudev-dev gcc-multilib g++-multilib && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /bolos-devenv
WORKDIR /bolos-devenv
ENV BOLOS_ENV=/bolos-devenv

RUN echo "5a261cac18c62d8b7e8c70beba2004bd  gcc-arm-none-eabi-5_3-2016q1-20160330-linux.tar.bz2" > gcc.md5
RUN wget https://launchpad.net/gcc-arm-embedded/5.0/5-2016-q1-update/+download/gcc-arm-none-eabi-5_3-2016q1-20160330-linux.tar.bz2
RUN md5sum -c gcc.md5
RUN tar xjvf gcc-arm-none-eabi-5_3-2016q1-20160330-linux.tar.bz2 && rm gcc-arm-none-eabi-5_3-2016q1-20160330-linux.tar.bz2

RUN echo "87b88d620284d1f0573923e6f7cc89edccf11d19ebaec1cfb83b4f09ac5db09c  clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz" > clang.sha256
RUN wget https://releases.llvm.org/8.0.0/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz
RUN shasum -a 256 -c clang.sha256
RUN tar xvf clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz && rm clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz
RUN ln -s clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-16.04 clang-arm-fropi


FROM base AS builder

RUN echo '#!/bin/bash\npython3 "$@"' > /usr/bin/python && \
    chmod +x /usr/bin/python

RUN git clone https://github.com/LedgerHQ/nanos-secure-sdk /nanos-secure-sdk
RUN git clone https://github.com/LedgerHQ/nanox-secure-sdk /nanox-secure-sdk

RUN mkdir -p /nanos
RUN mkdir -p /nanox

ENV BOLOS_SDK=/nanos-secure-sdk
WORKDIR /nanos-secure-sdk
RUN git checkout nanos-1612
WORKDIR /nanos
COPY glyphs glyphs
COPY src src
COPY vendor vendor
COPY Makefile Makefile
COPY nanos_icon_hns.gif nanos_icon_hns.gif
COPY nanox_icon_hns.gif nanox_icon_hns.gif
RUN make

ENV BOLOS_SDK=/nanox-secure-sdk
WORKDIR /nanox
COPY glyphs glyphs
COPY src src
COPY vendor vendor
COPY Makefile Makefile
COPY nanos_icon_hns.gif nanos_icon_hns.gif
COPY nanox_icon_hns.gif nanox_icon_hns.gif
RUN make
