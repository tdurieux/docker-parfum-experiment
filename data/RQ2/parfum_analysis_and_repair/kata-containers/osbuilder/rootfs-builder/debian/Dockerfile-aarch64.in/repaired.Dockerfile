#
# Copyright (c) 2020 ARM Limited
#
# SPDX-License-Identifier: Apache-2.0

# NOTE: OS_VERSION is set according to config.sh
from docker.io/debian:@OS_VERSION@

#environment variable declaration, etc
@SET_UP@

# RUN commands
RUN apt-get update && apt-get install --no-install-recommends -y \
    autoconf \
    automake \
    binutils \
    build-essential \
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
    sed \
    systemd \
    tar \
    vim && rm -rf /var/lib/apt/lists/*;
# This will install the proper golang to build Kata components
@INSTALL_GO@
@INSTALL_MUSL@
@INSTALL_RUST@
