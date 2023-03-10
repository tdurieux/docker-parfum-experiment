#
# Docker image to cross-compile EDK2 firmware binaries
#
FROM ubuntu:16.04

MAINTAINER Philippe Mathieu-Daudé <philmd@redhat.com>

# Install packages required to build EDK2
RUN apt update \
    && \

    DEBIAN_FRONTEND=noninteractive \
    apt -y install --assume-yes --no-install-recommends \
        build-essential \
        ca-certificates \
        dos2unix \
        gcc-aarch64-linux-gnu \
        gcc-arm-linux-gnueabi \
        git \
        iasl \
        make \
        nasm \
        python \
        uuid-dev \
    && \

    rm -rf /var/lib/apt/lists/*
