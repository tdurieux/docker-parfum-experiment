# SPDX-License-Identifier: BSD-2-Clause
# Copyright (C) 2020 - 2021 Intel Corporation.

# Pull base image
FROM centos:7

LABEL maintainer="patryk.kaminski@intel.com"

# Update the yum cache and install basic tools
RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum update -y && yum install -y \
    autoconf \
    automake \
    bash-completion \
    ca-certificates \
    expect \
    gcc-c++ \
    git \
    json-c-devel \
    keyutils-libs-devel \
    kmod-devel \
    libtool \
    libudev-devel \
    libuuid-devel \
    make \
    numactl \
    numactl-devel \
    pkgconfig \
    python3-pip \
    rpmdevtools \
    rpm-build \
    rubygem-asciidoctor \
    sudo \
    systemd \
    which \
    whois \
    xmlto \
 && yum clean all && rm -rf /var/cache/yum

# Install pytest
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir wheel
RUN pip3 install --no-cache-dir pytest==3.9.2

# Add user
ENV USER memkinduser
ENV USERPASS memkindpass
RUN useradd -m $USER -p $USERPASS
RUN gpasswd wheel -a $USER
RUN echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Create directory for memkind repository
WORKDIR /home/$USER/memkind

# Allow user to create files in the home directory
RUN chown -R $USER:wheel /home/$USER

# Change user to $USER
USER $USER
