#
# Copyright (c) 2018 SUSE
#
# SPDX-License-Identifier: Apache-2.0

# NOTE: OS_VERSION is set according to config.sh
from docker.io/debian:@OS_VERSION@

#environment variable declaration, etc
@SET_UP@

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
    libc-dev \
    libstdc++-6-dev \
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
