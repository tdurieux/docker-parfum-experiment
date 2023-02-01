# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2016-2020, Intel Corporation

#
# Dockerfile - a 'recipe' for Docker to build an image of ubuntu-based
#              environment prepared for running libvmemcache tests.
#

# Pull base image
FROM ubuntu:18.04
MAINTAINER piotr.balcer@intel.com

# Update the Apt cache and install basic tools
RUN apt-get update \
 && apt-get install --no-install-recommends -y software-properties-common \
	clang \
	cmake \
	curl \
	debhelper \
	devscripts \
	gcc \
	gdb \
	git \
	libunwind8-dev \
	pandoc \
	pkg-config \
	sudo \
	wget \
	whois \
	valgrind \
 && rm -rf /var/lib/apt/lists/*

# Add user
ENV USER user
ENV USERPASS pass
RUN useradd -m $USER -g sudo -p `mkpasswd $USERPASS`
USER $USER

# Set required environment variables
ENV OS ubuntu
ENV OS_VER 18.04
ENV PACKAGE_MANAGER deb
ENV NOTTY 1
