# Copyright 2018 Google LLC
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

ARG DISTRO_VERSION=14.04
FROM ubuntu:${DISTRO_VERSION}

# The default compilers in Ubuntu 14.04 are fairly old, we need to install
# from the ubuntu-toolchain-r/test PPA.  That changes the installation steps
# to the point where it is easier to just refactor like so:
RUN apt update && apt install -y software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    apt update && \
    apt install -y \
        automake \
        build-essential \
        ccache \
        clang-3.8 \
        cmake3 \
        curl \
        gcc-4.9 \
        g++-4.9 \
        git \
        libcurl4-openssl-dev \
        libssl-dev \
        libtool \
        lsb-release \
        make \
        tar \
        unzip \
        wget \
        zlib1g-dev \
        && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.8 100 && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.8 100 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.9 100 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 100

# Install Python packages used in the integration tests.
RUN apt update && apt install -y python-dev python-pip
RUN pip install --upgrade pip
RUN pip install flask httpbin gevent gunicorn crc32c

# Install the Cloud Bigtable emulator and the Cloud Bigtable command-line
# client.  They are used in the integration tests.
COPY . /var/tmp/ci
WORKDIR /var/tmp/downloads
RUN /var/tmp/ci/install-cloud-sdk.sh

# Install Bazel because some of the builds need it.
RUN /var/tmp/ci/install-bazel.sh
