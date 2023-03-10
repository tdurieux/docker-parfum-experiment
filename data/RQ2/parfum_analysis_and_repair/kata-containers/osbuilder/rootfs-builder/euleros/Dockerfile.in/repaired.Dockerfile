#
# Copyright (C) 2018 Huawei Technologies Co., Ltd
#
# SPDX-License-Identifier: Apache-2.0

FROM docker.io/euleros:@OS_VERSION@

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
    libstdc++-devel \
    libstdc++-static \
    m4 \
    make \
    sed \
    tar \
    vim \
    which \
    yum && rm -rf /var/cache/yum

# This will install the proper golang to build Kata components
@INSTALL_GO@

# several problems prevent us from building rust agent on euleros
# 1. There is no libstdc++.a. copy one from somewhere get through
#    compilation
# 2. The kernel (3.10.x) is too old, kernel-headers pacakge
# has no vm_socket.h because kernel has no vsock support or
# vsock header files

# We will disable rust agent build in rootfs.sh for euleros
# and alpine(musl cannot support proc-macro)
