#
# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2020-2022, Intel Corporation
#

#
# Dockerfile - a 'recipe' for Docker to build an image of environment
#              prepared for running tests of librpma.
#

# Pull base image
FROM opensuse/leap:latest
MAINTAINER tomasz.gromadzki@intel.com

# Update the OS
RUN zypper dup -y

# Update all packages
RUN zypper update -y

# base deps
ENV BASE_DEPS "\
	clang \
	gcc \
	git \
	make \
	pkg-config \
	sudo \
	which"

ENV TOOLS_DEPS "\
	python3-Jinja2"

ENV TESTS_DEPS "\
	python3 \
	python3-pip \
	python3-pylint \
	python3-pytest \
	python3-setuptools"

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
	file \
	gawk \
	groff \
	graphviz \
	libunwind-devel \
	pandoc \
	rpm-build \
	rdma-core-devel"

# Install all required packages
RUN zypper install -y \
	$BASE_DEPS \
	$TOOLS_DEPS \
	$TESTS_DEPS \
	$RPMA_DEPS

RUN pip3 install --no-cache-dir --upgrade pip

# Required by python3-pylint
RUN pip install --no-cache-dir setuptools

# Install cmocka
COPY install-cmocka.sh install-cmocka.sh
RUN ./install-cmocka.sh

# Install txt2man
COPY install-txt2man.sh install-txt2man.sh
RUN ./install-txt2man.sh

# Clean the package cache
RUN zypper clean all

# Add user
ENV USER user
ENV USERPASS p1a2s3s4
ENV PFILE ./password
RUN useradd -m $USER
RUN echo $USERPASS > $PFILE
RUN echo $USERPASS >> $PFILE
RUN passwd $USER < $PFILE
RUN rm -f $PFILE
RUN sed -i 's/# %wheel/%wheel/g' /etc/sudoers
RUN groupadd wheel
RUN gpasswd wheel -a $USER
USER $USER

# Set required environment variables
ENV OS opensuse/leap
ENV OS_VER latest
ENV PACKAGE_MANAGER rpm
ENV NOTTY 1

# install python modules for the default user
RUN pip3 install --no-cache-dir --user $PYTHON_DEPS
