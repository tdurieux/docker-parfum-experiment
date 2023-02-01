#
# Copyright 2016-2017, Intel Corporation
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
#              environment for building the PMEMFILE project.
#

# Pull base image
FROM fedora:25
MAINTAINER marcin.slusarz@intel.com

# Install basic tools
RUN dnf install -y \
	attr \
	autoconf \
	automake \
	bc \
	capstone-devel \
	clang \
	cmake \
	doxygen \
	fuse-devel \
	gcc \
	gdb \
	gettext \
	git \
	libacl-devel \
	libaio-devel \
	libattr-devel \
	libblkid-devel \
	libcap-devel \
	libunwind-devel \
	libuuid-devel \
	libtool \
	make \
	man \
	pandoc \
	perl-Text-Diff \
	passwd \
	python-pip \
	python3 \
	python3-coverage \
	rpm-build \
	sqlite \
	sudo \
	tcl-devel \
	wget \
	which \
	whois \
	xfsdump

# Upgrade pip
RUN pip install --upgrade pip

# Install codecov
RUN pip install codecov

# Install valgrind
COPY install-valgrind.sh install-valgrind.sh
RUN ./install-valgrind.sh

# Install nvml
COPY install-nvml.sh install-nvml.sh
RUN ./install-nvml.sh rpm

# Install syscall_intercept
COPY install-syscall_intercept.sh install-syscall_intercept.sh
RUN ./install-syscall_intercept.sh rpm

RUN curl -L -o /googletest-1.8.0.zip https://github.com/google/googletest/archive/release-1.8.0.zip

# Install pjdfstest
COPY 0001-disable-special-files-tests.patch 0001-disable-special-files-tests.patch
COPY install-pjdfstest.sh install-pjdfstest.sh
RUN ./install-pjdfstest.sh

# Add user
ENV USER user
ENV USERPASS pass
RUN useradd -m $USER
RUN echo $USERPASS | passwd $USER --stdin
RUN gpasswd wheel -a $USER

# Install ltp
COPY install-ltp.sh install-ltp.sh
RUN ./install-ltp.sh

# Install xfs
COPY 0001-enable-pmemfile.patch 0001-enable-pmemfile.patch
COPY install-xfs.sh install-xfs.sh
RUN ./install-xfs.sh

RUN dnf remove -y \
	autoconf \
	automake \
	doxygen \
	passwd \
	which \
	whois

RUN dnf autoremove -y

USER $USER

# Install sqlite
COPY install-sqlite.sh install-sqlite.sh
RUN ./install-sqlite.sh

# Set required environment variables
ENV OS fedora
ENV OS_VER 25
ENV PACKAGE_MANAGER rpm
ENV NOTTY 1

