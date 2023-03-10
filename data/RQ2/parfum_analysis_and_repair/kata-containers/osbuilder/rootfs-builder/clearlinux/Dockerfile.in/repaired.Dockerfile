#
# Copyright (c) 2018 Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0

From docker.io/fedora:30

@SET_PROXY@

RUN dnf -y update && dnf install -y \
    autoconf \
    automake \
    binutils \
    chrony \
    cmake \
    coreutils \
    curl \
    curl \
    gcc \
    gcc-c++ \
    git \
    glibc-common \
    glibc-devel \
    glibc-headers \
    glibc-static \
    glibc-utils \
    libseccomp \
    libseccomp-devel \
    libstdc++-devel \
    libstdc++-static \
    m4 \
    make \
    pkgconfig \
    sed \
    systemd \
    tar \
    vim \
    which

# This will install the proper golang to build Kata components