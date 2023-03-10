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
ARG build_options

ENV NGRAPH_TF_VERSION=master

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
    clang-format-3.9 \
    shellcheck \
    libusb-1.0-0-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -U virtualenv==16.0.0

#install latest cmake
ADD https://cmake.org/files/v3.19/cmake-3.19.2-Linux-x86_64.sh /cmake-3.19.2-Linux-x86_64.sh
RUN mkdir /opt/cmake
RUN sh /cmake-3.19.2-Linux-x86_64.sh --prefix=/opt/cmake --skip-license
RUN ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake
RUN cmake --version

#install Bazelisk
RUN mkdir /opt/bazelisk
ADD https://github.com/bazelbuild/bazelisk/releases/download/v1.7.4/bazelisk-linux-amd64 /opt/bazelisk/bazelisk-linux-amd64
RUN chmod +x /opt/bazelisk/bazelisk-linux-amd64 && ln -s /opt/bazelisk/bazelisk-linux-amd64 /usr/local/bin/bazel
RUN bazel

RUN git clone -b ${NGRAPH_TF_VERSION} https://github.com/tensorflow/ngraph-bridge.git /ngraph-bridge

WORKDIR /ngraph-bridge
RUN echo "Using build options: $build_options" && python3 ./build_ngtf.py $build_options
