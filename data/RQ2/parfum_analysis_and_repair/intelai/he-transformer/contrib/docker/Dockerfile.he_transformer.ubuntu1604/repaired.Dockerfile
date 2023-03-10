# ******************************************************************************
# Copyright 2018-2020 Intel Corporation
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
# ******************************************************************************

# Environment to build and unit-test he-transformer

FROM ubuntu:16.04
# with g++ 7.4.0
# with clang++ 6.0.1
# with python 3.5.2
# with cmake 3.14.4

RUN apt-get update && apt-get install --no-install-recommends -y \
        python3-pip virtualenv \
        python3-numpy python3-dev python3-wheel \
        git \
        unzip wget \
        sudo \
        bash-completion \
        build-essential cmake \
        software-properties-common \
        git \
        wget patch diffutils libtinfo-dev \
        autoconf libtool \
        doxygen graphviz \
        yapf3 python3-yapf && rm -rf /var/lib/apt/lists/*;

# Install clang-6
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
RUN apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-6.0 main"
RUN apt-get update
RUN apt-get install --no-install-recommends -y clang-6.0 && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean autoclean && \
        apt-get autoremove -y

# For ngraph-tf integration testing
RUN pip3 install --no-cache-dir --upgrade pip setuptools virtualenv==16.1.0

# SEAL requires newer version of CMake
RUN pip3 install --no-cache-dir cmake --upgrade

# Get g++-7
RUN add-apt-repository ppa:ubuntu-toolchain-r/test \
        && apt update \
        && apt install --no-install-recommends g++-7 -y && rm -rf /var/lib/apt/lists/*;

# Set g++-7 to default
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 50
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 50
RUN update-alternatives --set g++ /usr/bin/g++-7
RUN update-alternatives --set gcc /usr/bin/gcc-7

RUN cmake --version
RUN make --version
RUN gcc --version
RUN c++ --version
RUN clang++-6.0 --version
RUN python3 --version
RUN virtualenv --version

# Get bazel for ng-tf
RUN wget https://github.com/bazelbuild/bazel/releases/download/0.25.2/bazel-0.25.2-installer-linux-x86_64.sh
RUN chmod +x ./bazel-0.25.2-installer-linux-x86_64.sh
RUN bash ./bazel-0.25.2-installer-linux-x86_64.sh
WORKDIR /home
