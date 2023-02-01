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
    clang-analyzer \
    clang-tools-extra \
    cmake \
    curl \
    doxygen \
    gcc-c++ \
    git \
    grpc-devel \
    grpc-plugins \
    libcurl-devel \
    libcxx-devel \
    libcxxabi-devel \
    libtool \
    make \
    ncurses-term \
    openssl-devel \
    pkgconfig \
    protobuf-compiler \
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
WORKDIR /var/tmp/install/cbt-components
RUN wget -q https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-233.0.0-linux-x86_64.tar.gz
RUN sha256sum google-cloud-sdk-233.0.0-linux-x86_64.tar.gz | \
    grep -q '^a04ff6c4dcfc59889737810174b5d3c702f7a0a20e5ffcec3a5c3fccc59c3b7a '
RUN tar x -C /usr/local -f google-cloud-sdk-233.0.0-linux-x86_64.tar.gz
RUN /usr/local/google-cloud-sdk/bin/gcloud --quiet components install cbt bigtable

# Install Bazel too.
WORKDIR /var/tmp/ci
COPY install-bazel.sh /var/tmp/ci
RUN /var/tmp/ci/install-bazel.sh

WORKDIR /var/tmp/build
RUN wget -q https://github.com/google/crc32c/archive/1.0.6.tar.gz
RUN tar -xf 1.0.6.tar.gz
WORKDIR /var/tmp/build/crc32c-1.0.6
RUN cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_SHARED_LIBS=yes \
      -DCRC32C_BUILD_TESTS=OFF \
      -DCRC32C_BUILD_BENCHMARKS=OFF \
      -DCRC32C_USE_GLOG=OFF \
      -H. -Bcmake-out/crc32c
RUN cmake --build cmake-out/crc32c --target install -- -j $(nproc)
RUN ldconfig

# Install googletest.
WORKDIR /var/tmp/build
RUN wget -q https://github.com/google/googletest/archive/b6cd405286ed8635ece71c72f118e659f4ade3fb.tar.gz
RUN tar -xf b6cd405286ed8635ece71c72f118e659f4ade3fb.tar.gz
WORKDIR /var/tmp/build/googletest-b6cd405286ed8635ece71c72f118e659f4ade3fb
RUN cmake \
      -DCMAKE_BUILD_TYPE="Release" \
      -DBUILD_SHARED_LIBS=yes \
      -H. -Bcmake-out/googletest
RUN cmake --build cmake-out/googletest --target install -- -j ${NCPU}
RUN ldconfig
