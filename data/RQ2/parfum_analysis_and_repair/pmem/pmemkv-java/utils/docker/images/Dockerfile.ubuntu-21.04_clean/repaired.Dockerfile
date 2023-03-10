# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2016-2021, Intel Corporation

#
# Dockerfile - a 'recipe' for Docker to build an image of ubuntu-based
#              environment prepared for running pmemkv-java examples
#              e.g. with pmemkv downloaded from maven repository.
#

# Pull base image
FROM registry.hub.docker.com/library/ubuntu:21.04
MAINTAINER igor.chorazewicz@intel.com

# Set required environment variables
ENV OS ubuntu
ENV OS_VER 21.04_clean
ENV PACKAGE_MANAGER deb
ENV NOTTY 1
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# Additional parameters to build docker without building components
ARG SKIP_MAVEN_RUNTIME_SETUP

# Base development packages
ARG BASE_DEPS="\
	git"

# Dependencies for compiling pmemkv-java example(s)
ARG PMEMKV_JAVA_DEPS="\
	libpmemkv-dev \
	maven \
	openjdk-8-jdk"

# Misc for our builds/CI (optional)
ARG MISC_DEPS="\
	sudo \
	whois"

ENV DEBIAN_FRONTEND noninteractive

# Update the Apt cache and install basic tools
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
	${BASE_DEPS} \
	${PMEMKV_JAVA_DEPS} \
	${MISC_DEPS} \
 && rm -rf /var/lib/apt/lists/*

# Prepare extra maven params
# It's executed and its result is exported within 'install-dependencies.sh'
# To avoid setting this script up also in users' .bashrc,
# for a container runtime, set 'SKIP_MAVEN_RUNTIME_SETUP'
COPY setup-maven-settings.sh /opt/setup-maven-settings.sh

# Setup only maven settings.
# Offline dependencies are not useful within the image, since we need
# the internet connection anyway (for downloading the pmemkv from maven).
ARG SKIP_DEPENDENCIES_BUILD=1
COPY install-dependencies.sh install-dependencies.sh
RUN ./install-dependencies.sh

# Add user