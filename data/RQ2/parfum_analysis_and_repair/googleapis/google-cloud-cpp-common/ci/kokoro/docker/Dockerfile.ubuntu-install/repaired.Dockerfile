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

ARG DISTRO_VERSION=18.04
FROM ubuntu:${DISTRO_VERSION}
ARG NCPU=4

RUN apt-get update && \
    apt-get --no-install-recommends install -y \
        abi-compliance-checker \
        abi-dumper \
        apt-transport-https \
        apt-utils \
        automake \
        build-essential \
        ca-certificates \
        ccache \
        clang \
        clang-format-7 \
        cmake \
        ctags \
        curl \
        doxygen \
        gawk \
        git \
        gcc \
        g++ \
        cmake \
        libssl-dev \
        libtool \
        lsb-release \
        make \
        ninja-build \
        pkg-config \
        python3 \
        python3-pip \
        shellcheck \
        tar \
        unzip \
        wget \
        zlib1g-dev && rm -rf /var/lib/apt/lists/*;

# Install protobuf using CMake. Some distributions include protobuf, but gRPC
# requires 3.4.x or newer, and many of those distribution use older versions.
# We need to install both the debug and Release version because:
# - When using pkg-config, only the release version works, the pkg-config
#   file is hard-coded to search for `libprotobuf.so` (or `.a`)
# - When using CMake, only the version compiled with the same CMAKE_BUILD_TYPE
#   as the dependent (gRPC or google-cloud-cpp) works.
WORKDIR /var/tmp/build
RUN wget -q https://github.com/google/protobuf/archive/v3.11.3.tar.gz
RUN tar -xf v3.11.3.tar.gz && rm v3.11.3.tar.gz
WORKDIR /var/tmp/build/protobuf-3.11.3/cmake
RUN for build_type in "Debug" "Release"; do \
    cmake \
        -DCMAKE_BUILD_TYPE="${build_type}" \
        -DBUILD_SHARED_LIBS=yes \
        -Dprotobuf_BUILD_TESTS=OFF \
        -H. -Bcmake-out-${build_type}; \
    cmake --build cmake-out-${build_type} --target install -- -j ${NCPU}; \
  done
RUN ldconfig

# Many distributions include c-ares, but they do not include the CMake support
# files for the library, so manually install it.  c-ares requires two install
# steps because (1) the CMake-based build does not install pkg-config files,
# and (2) the Makefile-based build does not install CMake config files.
WORKDIR /var/tmp/build
RUN apt-get remove -y libc-ares-dev libc-ares2
RUN wget -q https://github.com/c-ares/c-ares/archive/cares-1_14_0.tar.gz
RUN tar -xf cares-1_14_0.tar.gz && rm cares-1_14_0.tar.gz
WORKDIR /var/tmp/build/c-ares-cares-1_14_0
RUN cmake \
      -DCMAKE_BUILD_TYPE="Release" \
      -DBUILD_SHARED_LIBS=yes \
      -H. -Bcmake-out
RUN cmake --build cmake-out --target install -- -j ${NCPU}
RUN ./buildconf
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN install -m 644 -D -t /usr/local/lib/pkgconfig libcares.pc
RUN ldconfig

# Install gRPC. Note that we use the system's zlib and ssl libraries.
# For similar reasons to c-ares (see above), we need two install steps.
WORKDIR /var/tmp/build
RUN wget -q https://github.com/grpc/grpc/archive/78ace4cd5dfcc1f2eced44d22d752f103f377e7b.tar.gz
RUN tar -xf 78ace4cd5dfcc1f2eced44d22d752f103f377e7b.tar.gz && rm 78ace4cd5dfcc1f2eced44d22d752f103f377e7b.tar.gz
WORKDIR /var/tmp/build/grpc-78ace4cd5dfcc1f2eced44d22d752f103f377e7b
RUN cmake \
      -DCMAKE_BUILD_TYPE="Release" \
      -DBUILD_SHARED_LIBS=yes \
      -DgRPC_BUILD_TESTS=OFF \
      -DgRPC_ZLIB_PROVIDER=package \
      -DgRPC_SSL_PROVIDER=package \
      -DgRPC_CARES_PROVIDER=package \
      -DgRPC_PROTOBUF_PROVIDER=package \
      -H. -Bcmake-out/grpc
RUN cmake --build cmake-out/grpc --target install -- -j ${NCPU}
RUN make install-pkg-config_c install-pkg-config_cxx install-certs
RUN ldconfig

# Install googleapis.
WORKDIR /var/tmp/build
RUN wget -q https://github.com/googleapis/cpp-cmakefiles/archive/v0.9.0.tar.gz
RUN tar -xf v0.9.0.tar.gz && rm v0.9.0.tar.gz
WORKDIR /var/tmp/build/cpp-cmakefiles-0.9.0
RUN cmake \
    -DBUILD_SHARED_LIBS=YES \
    -H. -Bcmake-out
RUN cmake --build cmake-out --target install -- -j ${NCPU}
RUN ldconfig

# Install googletest.
WORKDIR /var/tmp/build
RUN wget -q https://github.com/google/googletest/archive/release-1.10.0.tar.gz
RUN tar -xf release-1.10.0.tar.gz && rm release-1.10.0.tar.gz
WORKDIR /var/tmp/build/googletest-release-1.10.0
RUN cmake \
      -DCMAKE_BUILD_TYPE="Release" \
      -DBUILD_SHARED_LIBS=yes \
      -H. -Bcmake-out/googletest
RUN cmake --build cmake-out/googletest --target install -- -j ${NCPU}
RUN ldconfig

RUN find /usr/local -type d | xargs chmod 777

# Install Bazel because some of the builds need it.
WORKDIR /var/tmp/ci
COPY . /var/tmp/ci
RUN /var/tmp/ci/install-bazel.sh
