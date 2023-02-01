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

FROM ubuntu:trusty

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y -q && \
    apt-get install -y -q --no-install-recommends wget software-properties-common && \
    apt-get install -y -q --no-install-recommends \
        autoconf \
        bison \
        ca-certificates \
        ccache \
        flex \
        g++ \
        gcc \
        git \
        libbz2-dev \
        libdouble-conversion-dev \
        libgoogle-glog-dev \
        libsnappy-dev \
        libssl-dev \
        make \
        ninja-build \
        pkg-config \
        protobuf-compiler \
        python-pip \
        tzdata \
    && apt-get clean \
    && python -m pip install --upgrade pip \
    && pip install --upgrade cmake \
    && rm -rf /var/lib/apt/lists/*

# - Flight is deactivated because the OpenSSL in Ubuntu 14.04 is too old
# - Disabling Gandiva since LLVM 7 require gcc >= 4.9 toolchain
# - ORC has compilation warnings that cause errors on gcc 4.8
# - c-ares in Trusty isn't recognized by gRPC build system
# - libprotobuf-dev / libprotoc-dev in Trusty too old for gRPC
# - libbrotli-dev unavailable
# - libgflags-dev is too old
# - libre2-dev unavailable
# - liblz4-dev is too old
ENV CC=gcc \
     CXX=g++ \
     ARROW_BUILD_TESTS=ON \
     ARROW_DEPENDENCY_SOURCE=SYSTEM \
     ARROW_FLIGHT=OFF \
     ARROW_WITH_OPENSSL=OFF \
     ARROW_GANDIVA=OFF \
     ARROW_GANDIVA_JAVA=OFF \
     ARROW_ORC=OFF \
     ARROW_PARQUET=ON \
     ARROW_HOME=/usr \
     CMAKE_ARGS="-DThrift_SOURCE=BUNDLED \
-DBOOST_SOURCE=BUNDLED \
-Dbenchmark_SOURCE=BUNDLED \
-DBrotli_SOURCE=BUNDLED \
-Dc-ares_SOURCE=BUNDLED \
-DFlatbuffers_SOURCE=BUNDLED \
-Dgflags_SOURCE=BUNDLED \
-DGTest_SOURCE=BUNDLED \
-DgRPC_SOURCE=BUNDLED \
-DLz4_SOURCE=BUNDLED \
-DORC_SOURCE=BUNDLED \
-DProtobuf_SOURCE=BUNDLED \
-DRapidJSON_SOURCE=BUNDLED \
-DRE2_SOURCE=BUNDLED \
-DZSTD_SOURCE=BUNDLED"

# build and test
CMD ["arrow/ci/docker_build_and_test_cpp.sh"]
