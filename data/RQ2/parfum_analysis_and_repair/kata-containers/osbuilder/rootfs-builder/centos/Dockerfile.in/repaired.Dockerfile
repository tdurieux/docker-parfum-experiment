#
# Copyright (c) 2018 Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0

From docker.io/centos:@OS_VERSION@

@SET_PROXY@

RUN yum -y update && yum install -y \
    autoconf \
    automake \
    binutils \
    chrony \
    coreutils \
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
    sed \
    tar \
    vim \
    which && rm -rf /var/cache/yum

# install cmake because centos7's cmake is too old
@INSTALL_CMAKE@
@INSTALL_MUSL@
# This will install the proper golang to build Kata components
@INSTALL_GO@
@INSTALL_RUST@
