#
# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2016-2022, Intel Corporation
#

#
# Dockerfile - a 'recipe' for Docker to build an image of ubuntu-based
#              environment prepared for running tests of librpma.
#

# Pull base image
FROM ubuntu:20.04
MAINTAINER tomasz.gromadzki@intel.com

ENV DEBIAN_FRONTEND noninteractive

# Additional parameters to build docker without building components
ARG SKIP_SCRIPTS_DOWNLOAD

# Update the Apt cache and install basic tools
RUN apt-get update && apt-get dist-upgrade -y

# base deps
ENV BASE_DEPS "\
	apt-utils \
	build-essential \
	clang \
	devscripts \
	git \
	pkg-config \
	sudo \
	whois"

ENV EXAMPLES_DEPS "\
	libpmem-dev \
	libprotobuf-c-dev"

ENV TOOLS_DEPS "\
	python3-jinja2"

ENV TESTS_DEPS "\
	pylint3 \
	python3-pip \
	python3-pytest"

ENV PYTHON_DEPS "\
	coverage \
	deepdiff \
	markdown2 \
	matplotlib \
	paramiko \
	scp"

# RPMA deps
ENV RPMA_DEPS "\
	cmake \
	curl \
	gawk \
	groff \
	graphviz \
	libibverbs-dev \
	librdmacm-dev \
	libunwind-dev \
	pandoc"

# Install all required packages
RUN apt-get install -y --no-install-recommends \
	$BASE_DEPS \
	$EXAMPLES_DEPS \
	$TOOLS_DEPS \
	$TESTS_DEPS \
	$RPMA_DEPS \
&& rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --upgrade pip

# Install cmocka
COPY install-cmocka.sh install-cmocka.sh
RUN ./install-cmocka.sh

# Install txt2man
COPY install-txt2man.sh install-txt2man.sh
RUN ./install-txt2man.sh

# Download scripts required in run-*.sh
COPY download-scripts.sh download-scripts.sh
COPY 0001-fix-generating-gcov-files-and-turn-off-verbose-log.patch 0001-fix-generating-gcov-files-and-turn-off-verbose-log.patch
RUN ./download-scripts.sh

# Add user
ENV USER user
ENV USERPASS p1a2s3s4
RUN useradd -m $USER -g sudo -p `mkpasswd $USERPASS`
USER $USER

# Set required environment variables
ENV OS ubuntu
ENV OS_VER 20.04
ENV PACKAGE_MANAGER deb
ENV NOTTY 1

# install python modules for the default user
RUN pip3 install --no-cache-dir --user $PYTHON_DEPS
