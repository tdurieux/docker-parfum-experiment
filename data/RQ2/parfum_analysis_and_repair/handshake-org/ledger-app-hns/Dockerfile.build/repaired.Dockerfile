FROM ubuntu:18.04 AS base

RUN apt-get update && apt-get install --no-install-recommends -y python3.6 python3-pip python3-pil python3-setuptools python3-dev build-essential git wget tar libusb-1.0-0.dev libudev-dev gcc-multilib g++-multilib && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /bolos-devenv
WORKDIR /bolos-devenv
ENV BOLOS_ENV=/bolos-devenv

RUN echo "5a261cac18c62d8b7e8c70beba2004bd  gcc-arm-none-eabi-5_3-2016q1-20160330-linux.tar.bz2" > gcc.md5
RUN wget https://launchpad.net/gcc-arm-embedded/5.0/5-2016-q1-update/+download/gcc-arm-none-eabi-5_3-2016q1-20160330-linux.tar.bz2
RUN md5sum -c gcc.md5
RUN tar xjvf gcc-arm-none-eabi-5_3-2016q1-20160330-linux.tar.bz2 && rm gcc-arm-none-eabi-5_3-2016q1-20160330-linux.tar.bz2

RUN echo "78e6401f85a656e1915f189de90a1af8  clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz" > clang.md5
RUN wget https://releases.llvm.org/4.0.0/clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz
RUN md5sum -c clang.md5
RUN tar xvf clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz && rm clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz
RUN ln -s clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-16.04 clang-arm-fropi

RUN pip3 install --no-cache-dir virtualenv
RUN virtualenv ledger
RUN /bin/sh ledger/bin/activate
RUN pip3 install --no-cache-dir ledgerblue
RUN pip3 install --no-cache-dir Pillow


FROM base AS builder

# The below directives allow us to copy source files into the builder
# image without having to manually use --no-cache. By default, Docker
# will use cache even if the files being copies have changed.
ARG CACHE_BUST=123
ARG GIT_NAME=nanos-secure-sdk
ARG GIT_REF=nanos-1612
ENV CACHE_BUST $CACHE_BUST
ENV GIT_NAME $GIT_NAME
ENV GIT_REF $GIT_REF
ENV BOLOS_SDK=/nano-secure-sdk

RUN mkdir -p /ledger-app-hns
RUN git clone https://github.com/LedgerHQ/$GIT_NAME /nano-secure-sdk

WORKDIR /nano-secure-sdk
RUN git checkout $GIT_REF
RUN sed -i s/python/python3/g icon.py
RUN echo '#!/bin/bash\npython3 "$@"' > /usr/bin/python && \
    chmod +x /usr/bin/python

WORKDIR /ledger-app-hns
COPY glyphs glyphs
COPY src src
COPY vendor vendor
COPY Makefile Makefile
COPY nanos_icon_hns.gif nanos_icon_hns.gif
COPY nanox_icon_hns.gif nanox_icon_hns.gif
RUN make
