# ==============================================================================
#  Copyright 2019-2020 Intel Corporation
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
# ==============================================================================
# Docker file to setup build envrionment for nGraph-TensorFlow

FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y \
    vim \
    python \
    python-pip \
    python3-pip \
    git \
    unzip zip wget \
    sudo \
    zlib1g zlib1g-dev bash-completion \
    build-essential cmake \
    clang-format-3.9 && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -U virtualenv==16.0.0

#install latest cmake
ADD https://cmake.org/files/v3.7/cmake-3.7.2-Linux-x86_64.sh /cmake-3.7.2-Linux-x86_64.sh
RUN mkdir /opt/cmake
RUN sh /cmake-3.7.2-Linux-x86_64.sh --prefix=/opt/cmake --skip-license
RUN ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake
RUN cmake --version

#Install Bazel
ADD https://github.com/bazelbuild/bazel/releases/download/0.25.2/bazel-0.25.2-installer-linux-x86_64.sh ./bazel-0.25.2-installer-linux-x86_64.sh
RUN bash bazel-0.25.2-installer-linux-x86_64.sh
RUN bazel

#install gcc-4.8 and register both 7 and 4.8 with alternatives
RUN apt-get update && apt-get install --no-install-recommends -y gcc-4.8 g++-4.8 && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.8 && \
  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 --slave /usr/bin/g++ g++ /usr/bin/g++-7
