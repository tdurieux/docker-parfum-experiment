# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2016-2021, Intel Corporation

#
# Dockerfile - a 'recipe' for Docker to build an image of fedora-based
#              environment prepared for running pmemkv-java build and tests.
#

# Pull base image
FROM registry.fedoraproject.org/fedora:34
MAINTAINER igor.chorazewicz@intel.com

# Set required environment variables
ENV OS fedora
ENV OS_VER 34
ENV PACKAGE_MANAGER rpm
ENV NOTTY 1
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0

# Additional parameters to build docker without building components
ARG SKIP_PMDK_BUILD
ARG SKIP_LIBPMEMOBJ_CPP_BUILD
ARG SKIP_PMEMKV_BUILD
ARG SKIP_DEPENDENCIES_BUILD
ARG SKIP_MAVEN_RUNTIME_SETUP

# Base development packages
ARG BASE_DEPS="\
	cmake \
	gcc \
	gcc-c++ \
	git \
	make"

# Dependencies for compiling pmemkv-java project
ARG PMEMKV_JAVA_DEPS="\
	maven \
	java-1.8.0-openjdk-devel"

# PMDK's dependencies (optional; libpmemobj-devel package may be used instead)
ARG PMDK_DEPS="\
	autoconf \
	automake \
	daxctl-devel \
	gdb \
	man \
	ndctl-devel \
	pandoc \
	python3 \
	rpm-build \
	rpm-build-libs \
	rpmdevtools \
	which"

# Dependencies for compiling libpmemobj-cpp project (optional; libpmemobj++-devel package may be used instead)
ARG LIBPMEMOBJ_CPP_DEPS="\
	libatomic \
	tbb-devel"

# Dependencies for compiling pmemkv project (optional; pmemkv-devel package may be used instead)
ARG PMEMKV_DEPS="\
	memkind-devel \
	rapidjson-devel \
	tbb-devel"

# Misc for our builds/CI (optional)
ARG MISC_DEPS="\
	clang \
	hub \
	perl-Text-Diff \
	pkgconf \
	sudo"

# Update packages and install basic tools
RUN dnf update -y \
 && dnf install -y \
	${BASE_DEPS} \
	${PMEMKV_JAVA_DEPS} \
	${PMDK_DEPS} \
	${LIBPMEMOBJ_CPP_DEPS} \
	${PMEMKV_DEPS} \
	${MISC_DEPS} \
&& dnf clean all

# Install pmdk
COPY install-pmdk.sh install-pmdk.sh
RUN ./install-pmdk.sh rpm

# Install pmdk c++ bindings
COPY install-libpmemobj-cpp.sh install-libpmemobj-cpp.sh
RUN ./install-libpmemobj-cpp.sh RPM

# Prepare pmemkv
COPY prepare-pmemkv.sh prepare-pmemkv.sh
RUN ./prepare-pmemkv.sh RPM

# Prepare extra maven params
# It's executed and its result is exported within 'install-dependencies.sh'
# To avoid setting this script up also in users' .bashrc,
# for a container runtime, set 'SKIP_MAVEN_RUNTIME_SETUP'
COPY setup-maven-settings.sh /opt/setup-maven-settings.sh

# Install dependencies for the java binding so it can be built offline
COPY install-dependencies.sh install-dependencies.sh
RUN ./install-dependencies.sh RPM

# Add user