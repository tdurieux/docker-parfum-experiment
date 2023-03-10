FROM ubuntu:20.04

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y --no-install-recommends \
  gcc-multilib make libc6-dev git curl ca-certificates libc6-i386 && rm -rf /var/lib/apt/lists/*;

COPY install-musl.sh /
RUN sh /install-musl.sh i686

ENV PATH=$PATH:/musl-i686/bin:/rust/bin \
    CC_i686_unknown_linux_musl=musl-gcc
