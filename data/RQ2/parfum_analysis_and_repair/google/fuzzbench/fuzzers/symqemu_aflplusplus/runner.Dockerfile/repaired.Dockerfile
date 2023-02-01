# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM gcr.io/fuzzbench/base-image

RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN sed -i -- 's/# deb-src/deb-src/g' /etc/apt/sources.list
#RUN echo deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-10 main >> /etc/apt/sources.list && \
#    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
#RUN echo deb http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu xenial main >> /etc/apt/sources.list && \
#    apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 1E9377A2BA9EF27F
RUN apt-get update && \
    apt-get install --no-install-recommends -y wget libstdc++-5-dev libtool-bin automake flex bison \
                       libglib2.0-dev libpixman-1-dev python3-setuptools unzip \
                       apt-utils apt-transport-https ca-certificates && rm -rf /var/lib/apt/lists/*;

# Install the packages we need.
RUN apt-get install --no-install-recommends -y ninja-build python zlib1g-dev cargo && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y \
        libtool \
        wget \
        automake \
        autoconf \
        bison \
        git \
        build-essential \
        gdb \
        g++ \
        cmake \
        cargo \
        rustc \
        sudo \
        joe \
        vim \
        zlib1g \
        zlib1g-dev \
        wget \
        bison \
        flex \
        gdb \
        strace && rm -rf /var/lib/apt/lists/*;
RUN apt-get build-dep -y qemu

ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/out"

