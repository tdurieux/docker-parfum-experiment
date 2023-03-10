FROM debian:latest
MAINTAINER Nitrokey <info@nitrokey.com>
RUN apt-get update  \
  && apt-get install -y --no-install-recommends \
    make \
    git \
    gcc-arm-none-eabi \
    && rm -rf /var/lib/apt/lists/*

RUN arm-none-eabi-gcc --version