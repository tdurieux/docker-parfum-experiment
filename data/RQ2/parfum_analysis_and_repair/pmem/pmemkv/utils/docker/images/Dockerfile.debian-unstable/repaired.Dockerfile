# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2016-2021, Intel Corporation

#
# Dockerfile - a 'recipe' for Docker to build an image of debian-based
#              environment prepared for running pmemkv build and tests.
#

# Pull base image
FROM registry.hub.docker.com/library/debian:unstable
MAINTAINER igor.chorazewicz@intel.com

# Set required environment variables
ENV OS debian
ENV OS_VER unstable
ENV PACKAGE_MANAGER deb
ENV NOTTY 1

# Additional parameters to build docker without building components
ARG SKIP_VALGRIND_BUILD
ARG SKIP_PMDK_BUILD
ARG SKIP_LIBPMEMOBJCPP_BUILD

# Base development packages
ARG BASE_DEPS="\
	cmake \
	build-essential \
	git"

# Dependencies for compiling pmemkv project
ARG PMEMKV_DEPS="\
	libmemkind-dev \
	libtbb-dev \
	rapidjson-dev"

# PMDK's dependencies (optional; libpmemobj-dev package may be used instead)
ARG PMDK_DEPS="\
	autoconf \
	automake \
	debhelper \
	devscripts \
	gdb \
	libdaxctl-dev \
	libndctl-dev \
	pandoc \
	python3"

# libpmemobj-cpp's dependencies (optional; libpmemobj-cpp-dev package may be used instead)
ARG LIBPMEMOBJ_CPP_DEPS="\
	libatomic1 \
	libtbb-dev"

# pmem's Valgrind dependencies (optional; valgrind package may be used instead)
ARG VALGRIND_DEPS="\
	autoconf \
	automake"

# Examples (optional)
ARG EXAMPLES_DEPS="\
	libncurses5-dev \
	libsfml-dev"

# Documentation (optional)
ARG DOC_DEPS="\
	doxygen \
	graphviz"

# Tests (optional)
ARG TESTS_DEPS="\
	gdb \
	libc6-dbg \
	libunwind-dev"

# Misc for our builds/CI (optional)
ARG MISC_DEPS="\
	clang \
	libtext-diff-perl \
	pkg-config \
	sudo \
	whois"

ENV DEBIAN_FRONTEND noninteractive

# Update the apt cache and install basic tools
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
	${BASE_DEPS} \
	${PMEMKV_DEPS} \
	${PMDK_DEPS} \
	${LIBPMEMOBJ_CPP_DEPS} \
	${VALGRIND_DEPS} \
	${EXAMPLES_DEPS} \
	${DOC_DEPS} \
	${TESTS_DEPS} \
	${MISC_DEPS} \
 && rm -rf /var/lib/apt/lists/*

# Install valgrind
COPY install-valgrind.sh install-valgrind.sh
RUN ./install-valgrind.sh

# Install pmdk
COPY install-pmdk.sh install-pmdk.sh
RUN ./install-pmdk.sh dpkg

# Install pmdk c++ bindings
COPY install-libpmemobj-cpp.sh install-libpmemobj-cpp.sh
RUN ./install-libpmemobj-cpp.sh DEB

# Add user