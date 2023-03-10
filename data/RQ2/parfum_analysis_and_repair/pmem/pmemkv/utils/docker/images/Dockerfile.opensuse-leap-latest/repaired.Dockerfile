# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2016-2021, Intel Corporation

#
# Dockerfile - a 'recipe' for Docker to build an image of opensuse-based
#              environment prepared for running pmemkv build and tests.
#

# Pull base image
FROM registry.opensuse.org/opensuse/leap:latest
MAINTAINER igor.chorazewicz@intel.com

# Set required environment variables
ENV OS opensuse-leap
ENV OS_VER latest
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
# NOTE: tbb-devel is installed from additional repo; see below
ARG PMEMKV_DEPS="\
	memkind-devel \
	rapidjson-devel"

# PMDK's dependencies (optional; libpmemobj-devel package may be used instead)
ARG PMDK_DEPS="\
	autoconf \
	automake \
	fdupes \
	gdb \
	libndctl-devel \
	man \
	pandoc \
	python3 \
	rpm-build \
	rpmdevtools \
	which"

# libpmemobj-cpp's dependencies (optional; libpmemobj-cpp-devel package may be used instead)
# NOTE: tbb-devel is installed from additional repo; see below
ARG LIBPMEMOBJ_CPP_DEPS="\
	libatomic1"

# pmem's Valgrind dependencies (optional; valgrind-devel package may be used instead)
ARG VALGRIND_DEPS="\
	autoconf \
	automake"

# Examples (optional)
ARG EXAMPLES_DEPS="\
	ncurses-devel"

# Documentation (optional)
ARG DOC_DEPS="\
	doxygen \
	graphviz"

# Tests (optional)
ARG TESTS_DEPS="\
	gdb \
	glibc-debuginfo \
	libunwind-devel"

# Misc for our builds/CI (optional)
ARG MISC_DEPS="\
	clang \
	perl-Text-Diff \
	pkg-config \
	sudo"

# Update the OS, packages and install basic tools;
# using additional repos for glibc debuginfo and for latest tbb
RUN zypper dup -y \
 && zypper update -y \
 && zypper mr -e repo-debug \
 && zypper install -y \
	${BASE_DEPS} \
	${PMEMKV_DEPS} \
	${PMDK_DEPS} \
	${LIBPMEMOBJ_CPP_DEPS} \
	${VALGRIND_DEPS} \
	${EXAMPLES_DEPS} \
	${DOC_DEPS} \
	${TESTS_DEPS} \
	${MISC_DEPS} \
 && zypper addrepo https://download.opensuse.org/repositories/Education/openSUSE_Leap_15.1/ education \
 && zypper --gpg-auto-import-keys install -y tbb-devel \
 && zypper clean all

# Install valgrind
COPY install-valgrind.sh install-valgrind.sh
RUN ./install-valgrind.sh opensuse

# Install pmdk
COPY install-pmdk.sh install-pmdk.sh
RUN ./install-pmdk.sh rpm

# Install pmdk c++ bindings
COPY install-libpmemobj-cpp.sh install-libpmemobj-cpp.sh
RUN ./install-libpmemobj-cpp.sh RPM

# Add user