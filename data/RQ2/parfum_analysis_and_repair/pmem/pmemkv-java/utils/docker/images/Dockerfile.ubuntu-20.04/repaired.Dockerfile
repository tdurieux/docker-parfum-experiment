# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2016-2021, Intel Corporation

#
# Dockerfile - a 'recipe' for Docker to build an image of ubuntu-based
#              environment prepared for running pmemkv-java build and tests.
#

# Pull base image
FROM registry.hub.docker.com/library/ubuntu:20.04
MAINTAINER igor.chorazewicz@intel.com

# Set required environment variables
ENV OS ubuntu
ENV OS_VER 20.04
ENV PACKAGE_MANAGER deb
ENV NOTTY 1
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# Additional parameters to build docker without building components
ARG SKIP_PMDK_BUILD
ARG SKIP_LIBPMEMOBJ_CPP_BUILD
ARG SKIP_PMEMKV_BUILD
ARG SKIP_DEPENDENCIES_BUILD
ARG SKIP_MAVEN_RUNTIME_SETUP

# Base development packages
ARG BASE_DEPS="\
	cmake \
	build-essential \
	git"

# Dependencies for compiling pmemkv-java project
ARG PMEMKV_JAVA_DEPS="\
	maven \
	openjdk-8-jdk"

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

# Dependencies for compiling libpmemobj-cpp project (optional; libpmemobj-cpp-dev package may be used instead)
ARG LIBPMEMOBJ_CPP_DEPS="\
	libatomic1 \
	libtbb-dev \
	libunwind8-dev"

# Dependencies for compiling pmemkv project (optional; libpmemkv-dev package may be used instead)
ARG PMEMKV_DEPS="\
	libmemkind-dev \
	libtbb-dev \
	libunwind8-dev \
	rapidjson-dev"

# Misc for our builds/CI (optional)
ARG MISC_DEPS="\
	clang \
	pkg-config \
	sudo \
	whois"

ENV DEBIAN_FRONTEND noninteractive

# Update the Apt cache and install basic tools
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
	${BASE_DEPS} \
	${PMEMKV_JAVA_DEPS} \
	${PMDK_DEPS} \
	${LIBPMEMOBJ_CPP_DEPS} \
	${PMEMKV_DEPS} \
	${MISC_DEPS} \
 && rm -rf /var/lib/apt/lists/*

# Install pmdk
COPY install-pmdk.sh install-pmdk.sh
RUN ./install-pmdk.sh dpkg

# Install pmdk c++ bindings
COPY install-libpmemobj-cpp.sh install-libpmemobj-cpp.sh
RUN ./install-libpmemobj-cpp.sh DEB

# Prepare pmemkv
COPY prepare-pmemkv.sh prepare-pmemkv.sh
RUN ./prepare-pmemkv.sh DEB

# Prepare extra maven params
# It's executed and its result is exported within 'install-dependencies.sh'
# To avoid setting this script up also in users' .bashrc,
# for a container runtime, set 'SKIP_MAVEN_RUNTIME_SETUP'
COPY setup-maven-settings.sh /opt/setup-maven-settings.sh

# Install dependencies for the java binding so it can be built offline
COPY install-dependencies.sh install-dependencies.sh
RUN ./install-dependencies.sh DEB

# Add user