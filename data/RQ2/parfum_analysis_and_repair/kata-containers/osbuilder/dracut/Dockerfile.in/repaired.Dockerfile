#
# Copyright (c) 2019 SUSE LLC
#
# SPDX-License-Identifier: Apache-2.0

from opensuse/tumbleweed

RUN zypper --non-interactive refresh; \
    zypper --non-interactive install --no-recommends --force-resolution \
    autoconf \
    automake \
    binutils \
    cmake \
    coreutils \
    cpio \
    curl \
    dracut \
    gcc \
    gcc-c++ \
    git-core \
    glibc-devel \
    glibc-devel-static \
    glibc-utils \
    libstdc++-devel \
    linux-glibc-devel \
    m4 \
    make \
    sed \
    tar \
    vim \
    which; \
    zypper --non-interactive clean --all;


# This will install the proper golang to build Kata components