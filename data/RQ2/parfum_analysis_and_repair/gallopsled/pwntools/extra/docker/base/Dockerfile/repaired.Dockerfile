############################################################
# Dockerfile to build Pwntools container
# Based on Ubuntu
############################################################

FROM ubuntu:bionic
MAINTAINER Maintainer Gallopsled et al.

env DEBIAN_FRONTEND=noninteractive
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update \
    && apt-get install -y --no-install-recommends locales \
    && locale-gen en_US.UTF-8 \
    && apt-get install --no-install-recommends -y \
        build-essential \
        elfutils \
        git \
        libssl-dev \
        libffi-dev \
        python \
        python-pip \
        python-dev \
        python3 \
        python3-pip \
        python3-dev \
        qemu-user-static \
        binutils-arm-linux-gnueabihf \
        binutils-aarch64-linux-gnu \
        binutils-mips-linux-gnu \
        binutils-mipsel-linux-gnu \
        binutils-powerpc-linux-gnu \
        binutils-powerpc64-linux-gnu \
        binutils-sparc64-linux-gnu \
        tmux \
    && pip install --no-cache-dir --upgrade pip \
    && python -m pip install --upgrade pwntools \
    && pip3 install --no-cache-dir --upgrade pip \
    && python3 -m pip install --upgrade pwntools \
    && PWNLIB_NOTERM=1 pwn update \
    && apt-get install --no-install-recommends -y sudo \
    && useradd -m pwntools \
    && passwd --delete --unlock pwntools \
    && echo "pwntools ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/pwntools && rm -rf /var/lib/apt/lists/*;
USER pwntools
WORKDIR /home/pwntools
