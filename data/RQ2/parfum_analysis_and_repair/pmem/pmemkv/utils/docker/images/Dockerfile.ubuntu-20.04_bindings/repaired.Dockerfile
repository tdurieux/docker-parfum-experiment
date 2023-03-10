# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2016-2021, Intel Corporation

#
# Dockerfile - a 'recipe' for Docker to build an image of ubuntu-based
#				environment prepared for executing build and tests
#				of pmemkv-* bindings repositories.
#				Rapidjson is installed from sources because of package bug.
#

# Pull base image
FROM registry.hub.docker.com/library/ubuntu:20.04
MAINTAINER igor.chorazewicz@intel.com

# Set required environment variables
ENV OS ubuntu
ENV OS_VER 20.04_bindings
ENV PACKAGE_MANAGER deb
ENV NOTTY 1
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

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
	libtbb-dev"

# Dependencies for compiling and testing pmemkv bindings
ARG PMEMKV_BINDINGS_DEPS="\
	maven \
	npm \
	openjdk-8-jdk \
	python3-dev \
	python3-pip \
	ruby-dev"

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

# Dependencies for compiling libpmemobj-cpp project
ARG LIBPMEMOBJ_CPP_DEPS="\
	libatomic1 \
	libtbb-dev"

# Misc for our builds/CI (optional)
ARG MISC_DEPS="\
	pkg-config \
	sudo \
	whois"

ENV DEBIAN_FRONTEND noninteractive

# Update the apt cache and install basic tools
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
	${BASE_DEPS} \
	${PMEMKV_DEPS} \
	${PMEMKV_BINDINGS_DEPS} \
	${PMDK_DEPS} \
	${LIBPMEMOBJ_CPP_DEPS} \
	${MISC_DEPS} \
 && rm -rf /var/lib/apt/lists/*

# Install rapidjson from sources
COPY install-rapidjson.sh install-rapidjson.sh
RUN ./install-rapidjson.sh

# Install pmdk
COPY install-pmdk.sh install-pmdk.sh
RUN ./install-pmdk.sh dpkg

# Install pmdk c++ bindings
COPY install-libpmemobj-cpp.sh install-libpmemobj-cpp.sh
RUN ./install-libpmemobj-cpp.sh DEB

# Install bindings' dependencies
RUN pip3 install --no-cache-dir pytest setuptools wheel
COPY install-bindings-dependencies.sh install-bindings-dependencies.sh
RUN ./install-bindings-dependencies.sh

# Add user
ENV USER user
ENV USERPASS pass
RUN useradd -m $USER -g sudo -p `mkpasswd $USERPASS`
USER $USER
