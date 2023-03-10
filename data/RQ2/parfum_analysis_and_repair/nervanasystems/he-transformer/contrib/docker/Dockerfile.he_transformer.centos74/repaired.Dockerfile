# ******************************************************************************
# Copyright 2018-2019 Intel Corporation
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

# Environment to build and unit-test he-transformer on fedora27
# with gcc 7.3.1
# with cmake 3.13.5
# with clang 5.0.1
# with python version 3.6.8

FROM centos:7

RUN yum -y update && \
    yum -y --enablerepo=extras install epel-release && \
    yum -y install \
    gcc gcc-c++ \
    cmake3 make \
    git \
    wget patch diffutils zlib-devel ncurses-devel libtinfo-dev \
    python python-devel python-setuptools \
    python3 python36-devel python3-setuptools \
    which unzip && rm -rf /var/cache/yum

RUN yum -y install centos-release-scl && \
    yum install -y devtoolset-7 llvm-toolset-7 && rm -rf /var/cache/yum

# For ngraph-tf integration testing
RUN easy_install pip
RUN pip install --no-cache-dir --upgrade pip setuptools virtualenv==16.0.0

SHELL [ "/usr/bin/scl", "enable", "devtoolset-7", "llvm-toolset-7"]

RUN ln -s /usr/bin/cmake3 /usr/bin/cmake

RUN cmake --version
RUN make --version
RUN gcc --version
RUN c++ --version
RUN clang --version
RUN clang++ --version
RUN python3 --version
RUN virtualenv --version

# Get bazel
RUN wget https://github.com/bazelbuild/bazel/releases/download/0.25.2/bazel-0.25.2-installer-linux-x86_64.sh
RUN chmod +x ./bazel-0.25.2-installer-linux-x86_64.sh
RUN bash ./bazel-0.25.2-installer-linux-x86_64.sh

WORKDIR /home