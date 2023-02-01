# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

FROM debian:testing

# install build essentials
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -y -q && \
    apt-get install -y -q --no-install-recommends \
        autoconf \
        ca-certificates \
        ccache \
        clang-7 \
        cmake \
        g++ \
        gcc \
        git \
        libbenchmark-dev \
        libboost-all-dev \
        libbrotli-dev \
        libbz2-dev \
        libc-ares-dev \
        libdouble-conversion-dev \
        libgflags-dev \
        libgmock-dev \
        libgoogle-glog-dev \
        libgtest-dev \
        liblz4-dev \
        libprotobuf-dev \
        libprotoc-dev \
        libre2-dev \
        libsnappy-dev \
        libssl-dev \
        libthrift-dev \
        libzstd-dev \
        llvm-7-dev \
        make \
        ninja-build \
        openjdk-11-jdk \
        openjdk-11-jdk-headless \
        pkg-config \
        protobuf-compiler \
        rapidjson-dev \
        thrift-compiler \
        tzdata \
        wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV CC=gcc \
     CXX=g++ \
     ARROW_BUILD_TESTS=ON \
     ARROW_DEPENDENCY_SOURCE=SYSTEM \
     ARROW_FLIGHT=ON \
     ARROW_GANDIVA=ON \
     ARROW_GANDIVA_JAVA=ON \
     ARROW_HOME=/usr \
     JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 \
     CMAKE_ARGS="-DFlatbuffers_SOURCE=BUNDLED \
-Dc-ares_SOURCE=BUNDLED \
-DgRPC_SOURCE=BUNDLED \
-DORC_SOURCE=BUNDLED"

# build and test
CMD ["arrow/ci/docker_build_and_test_cpp.sh"]
