#
# Copyright 2016-2020, Intel Corporation
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in
#       the documentation and/or other materials provided with the
#       distribution.
#
#     * Neither the name of the copyright holder nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#
# Dockerfile - a 'recipe' for Docker to build an image of fedora-based
#              environment for building the VMEM project.
#

# Pull base image
FROM fedora:28
MAINTAINER piotr.balcer@intel.com

# Install basic tools
RUN dnf update -y

RUN dnf install -y \
	asciidoc \
	asciidoctor \
	autoconf \
	automake \
	bc \
	clang \
	file \
	findutils \
	gcc \
	gdb \
	git \
	hub \
	lbzip2 \
	libtool \
	libunwind-devel \
	make \
	man \
	pandoc \
	passwd \
	pkgconfig \
	rpm-build \
	rpm-build-libs \
	rpmdevtools \
	rsync \
	sudo \
	tar \
	wget \
	which \
	xmlto

RUN dnf clean all

# Install valgrind
COPY install-valgrind.sh install-valgrind.sh
RUN ./install-valgrind.sh

# Add user
ENV USER vmemuser
ENV USERPASS vmempass
RUN useradd -m $USER
RUN echo $USERPASS | passwd $USER --stdin
RUN gpasswd wheel -a $USER
USER $USER

# Set required environment variables