# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2016-2021, Intel Corporation

#
# Dockerfile - a 'recipe' for Docker to build an image of Fedora-based
#              environment prepared for running pmemkv build and tests.
#              PMDK (libpmem & libpmemobj) and Valgrind are installed from dnf repo.
#

# Pull base image
FROM registry.fedoraproject.org/fedora:rawhide
MAINTAINER igor.chorazewicz@intel.com

# Set required environment variables
ENV OS fedora
ENV OS_VER rawhide
ENV PACKAGE_MANAGER rpm
ENV NOTTY 1

# Additional parameters to build docker without building components
ARG SKIP_VALGRIND_BUILD
ARG SKIP_PMDK_BUILD
ARG SKIP_LIBPMEMOBJCPP_BUILD

# Base development packages
ARG BASE_DEPS="\
	cmake \
	gcc \
	gcc-c++ \
	git \
	make"

# Dependencies for compiling pmemkv project
ARG PMEMKV_DEPS="\
	memkind-devel \
	rapidjson-devel \
	tbb-devel"

# libpmemobj-cpp's dependencies (optional; libpmemobj++-devel package may be used instead)
ARG LIBPMEMOBJ_CPP_DEPS="\
	libatomic \
	libpmemobj-devel \
	rpm-build \
	tbb-devel"

# Examples (optional)
ARG EXAMPLES_DEPS="\
	ncurses-devel \
	SFML-devel"

# Documentation (optional)
ARG DOC_DEPS="\
	doxygen \
	graphviz"

# Tests (optional)
# NOTE: glibc is installed as a separate command; see below
ARG TESTS_DEPS="\
	gdb \
	libpmem-devel \
	libunwind-devel \
	pmempool \
	valgrind-devel"

# Misc for our builds/CI (optional)
ARG MISC_DEPS="\
	clang \
	perl-Text-Diff \
	pkgconf \
	sudo"

# Update packages and install basic tools
RUN dnf update -y \
 && dnf install -y \
	${BASE_DEPS} \
	${PMEMKV_DEPS} \
	${LIBPMEMOBJ_CPP_DEPS} \
	${EXAMPLES_DEPS} \
	${DOC_DEPS} \
	${TESTS_DEPS} \
	${MISC_DEPS} \
 && dnf debuginfo-install -y glibc \
 && dnf clean all

# Install pmdk c++ bindings
COPY install-libpmemobj-cpp.sh install-libpmemobj-cpp.sh
RUN ./install-libpmemobj-cpp.sh RPM

# Add user