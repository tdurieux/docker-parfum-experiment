#
# Copyright (c) 2018  Yash Jain
#
# SPDX-License-Identifier: Apache-2.0

#ubuntu: docker image to be used to create a rootfs
#@OS_VERSION@: Docker image version to build this dockerfile
from docker.io/ubuntu:@OS_VERSION@

#environment variable declaration, etc
@SET_UP@

# This dockerfile needs to provide all the componets need to build a rootfs
# Install any package need to create a rootfs (package manager, extra tools)

# RUN commands
RUN apt-get update && apt-get --no-install-recommends install -y \
    apt-utils \
    autoconf \
    automake \
    binutils \
    build-essential \
    ca-certificates \
    chrony \
    cmake \
    coreutils \
    curl \
    debianutils \
    debootstrap \
    g++ \
    gcc \
    git \
    libc6-dev \
    libstdc++-8-dev \
    m4 \
    make \
    musl \
    musl-dev \
    musl-tools \
    sed \
    systemd \
    tar \
    vim \
    wget && rm -rf /var/lib/apt/lists/*;
# This will install the proper golang to build Kata components
@INSTALL_GO@
@INSTALL_RUST@
