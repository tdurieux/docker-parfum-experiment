# Copyright 2017 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ARG DISTRO_VERSION=30
FROM fedora:${DISTRO_VERSION}

RUN dnf makecache && dnf install -y \
    autoconf \
    automake \
    c-ares-devel \
    ccache \
    clang \
    clang-tools-extra \
    cmake \
    curl \
    dia \
    doxygen \
    gcc-c++ \
    git \
    libcurl-devel \
    libcxx-devel \
    libcxxabi-devel \
    libtool \
    make \
    ncurses-term \
    openssl-devel \
    pkgconfig \
    python \
    shtool \
    unzip \
    wget \
    which \
    zlib-devel

RUN pip install --upgrade pip
RUN pip install httpbin flask gevent gunicorn crc32c

# Install the Cloud Bigtable emulator and the Cloud Bigtable command-line
# client.  They are used in the integration tests.
COPY . /var/tmp/ci
WORKDIR /var/tmp/downloads
RUN /var/tmp/ci/install-cloud-sdk.sh

# Install Bazel because some of the builds need it.
RUN /var/tmp/ci/install-bazel.sh
