# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2016-2020, Intel Corporation

#
# Dockerfile - a 'recipe' for Docker to build an image of fedora-based
#              environment prepared for running libvmemcache tests.
#

# Pull base image
FROM fedora:28
MAINTAINER piotr.balcer@intel.com

# Install basic tools
RUN dnf update -y \
 && dnf install -y \
	clang \
	cmake \
	gcc \
	git \
	hub \
	libunwind-devel \
	make \
	man \
	pandoc \
	passwd \
	rpm-build \
	sudo \
	tar \
	wget \
	which \
	valgrind \
	valgrind-devel \
 && dnf clean all

# Add user
ENV USER user
ENV USERPASS pass
RUN useradd -m $USER
RUN echo $USERPASS | passwd $USER --stdin
RUN gpasswd wheel -a $USER
USER $USER

# Set required environment variables