# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2016-2021, Intel Corporation

#
# Dockerfile - a 'recipe' for Docker to build an image of fedora-based
#              environment prepared for running libpmemobj-cpp tests.
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

# Base development packages
ARG BASE_DEPS="\
	cmake \
	gcc \
	gcc-c++ \
	git \
	make"

# Dependencies for compiling libpmemobj-cpp project
ARG LIBPMEMOBJ_CPP_DEPS="\
	libatomic \
	libpmemobj-devel \
	tbb-devel"

# Examples (optional)
ARG EXAMPLES_DEPS="\
	ncurses-devel \
	SFML-devel"

# Documentation (optional)
ARG DOC_DEPS="\
	doxygen"

# Tests (optional)
# NOTE: glibc is installed as a separate command; see below
ARG TESTS_DEPS="\
	gdb \
	libpmem-devel \
	libunwind-devel \
	pmempool \
	rpm-build \
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
	${LIBPMEMOBJ_CPP_DEPS} \
	${EXAMPLES_DEPS} \
	${DOC_DEPS} \
	${TESTS_DEPS} \
	${MISC_DEPS} \
 && dnf debuginfo-install -y glibc \
 && dnf clean all

# Add user