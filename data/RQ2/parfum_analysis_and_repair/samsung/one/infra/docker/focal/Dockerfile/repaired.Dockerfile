# Copyright (c) 2020 Samsung Electronics Co., Ltd. All Rights Reserved
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

FROM ubuntu:20.04

ARG UBUNTU_MIRROR

# Install 'add-apt-repository'
RUN apt-get update && apt-get -qqy --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;

# Build tool
RUN apt-get update && apt-get -qqy --no-install-recommends install build-essential cmake scons git lcov g++-arm-linux-gnueabihf g++-aarch64-linux-gnu && rm -rf /var/lib/apt/lists/*;

# Debian build tool
RUN apt-get update && apt-get -qqy --no-install-recommends install fakeroot devscripts debhelper python3-all dh-python && rm -rf /var/lib/apt/lists/*;

# Install extra dependencies (Caffe, nnkit)
RUN apt-get update && apt-get -qqy --no-install-recommends install libboost-all-dev libgflags-dev libgoogle-glog-dev libatlas-base-dev libhdf5-dev && rm -rf /var/lib/apt/lists/*;

# Install protocol buffer
RUN apt-get update && apt-get -qqy --no-install-recommends install libprotobuf-dev protobuf-compiler && rm -rf /var/lib/apt/lists/*;

# Additonal tools
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get --no-install-recommends -qqy install doxygen graphviz wget zip unzip clang-format-8 python3 python3-pip python3-venv hdf5-tools pylint curl && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install yapf==0.22.0 numpy

# Install google test (source)
RUN apt-get update && apt-get -qqy --no-install-recommends install libgtest-dev && rm -rf /var/lib/apt/lists/*;

# Install gbs & sdb
RUN echo 'deb [trusted=yes] http://download.tizen.org/tools/latest-release/Ubuntu_20.04/ /' | cat >> /etc/apt/sources.list
RUN apt-get update && apt-get -qqy --no-install-recommends install gbs && rm -rf /var/lib/apt/lists/*;
RUN wget https://download.tizen.org/sdk/tizenstudio/official/binary/sdb_4.2.19_ubuntu-64.zip -O sdb.zip
RUN unzip -d tmp sdb.zip && rm sdb.zip
RUN cp tmp/data/tools/sdb /usr/bin/. && rm -rf tmp/*

# Clean archives (to reduce image size)
RUN apt-get clean -y
