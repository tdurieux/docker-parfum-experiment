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

#
# WARNING: This is an automatically generated file. Consider changing the
#     sources instead. You can find the source templates and scripts at:
#     https://github.com/googleapis/google-cloud-cpp-common/tree/master/ci/templates
#

ARG DISTRO_VERSION=stretch
FROM debian:${DISTRO_VERSION} AS devtools
ARG NCPU=4

## [START INSTALL.md]

# First install the development tools and libcurl.
# On Debian 9, libcurl links against openssl-1.0.2, and one must link
# against the same version or risk an inconsistent configuration of the library.
# This is especially important for multi-threaded applications, as openssl-1.0.2
# requires explicitly setting locking callbacks. Therefore, to use libcurl one
# must link against openssl-1.0.2. To do so, we need to install libssl1.0-dev.
# Note that this removes libssl-dev if you have it installed already, and would
# prevent you from compiling against openssl-1.1.0.

# ```bash
RUN apt-get update && \
    apt-get --no-install-recommends install -y apt-transport-https apt-utils \
        automake build-essential cmake ca-certificates git gcc g++ cmake libc-ares-dev \
        libc-ares2 libcurl4-openssl-dev libssl1.0-dev make m4 pkg-config tar \
        wget zlib1g-dev && rm -rf /var/lib/apt/lists/*;
# ```

# #### Protobuf

# We need to install a version of Protobuf that is recent enough to support the
# Google Cloud Platform proto files:

# ```bash
WORKDIR /var/tmp/build
RUN wget -q https://github.com/google/protobuf/archive/v3.11.3.tar.gz && \
    tar -xf v3.11.3.tar.gz && \
    cd protobuf-3.11.3/cmake && \
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_SHARED_LIBS=yes \
        -Dprotobuf_BUILD_TESTS=OFF \
        -H. -Bcmake-out && \
    cmake --build cmake-out -- -j ${NCPU:-4} && \
    cmake --build cmake-out --target install -- -j ${NCPU:-4} && \
    ldconfig && rm v3.11.3.tar.gz
# ```

# #### gRPC

# To install gRPC we first need to configure pkg-config to find the version of
# Protobuf we just installed in `/usr/local`:

# ```bash
WORKDIR /var/tmp/build
RUN wget -q https://github.com/grpc/grpc/archive/78ace4cd5dfcc1f2eced44d22d752f103f377e7b.tar.gz && \
    tar -xf 78ace4cd5dfcc1f2eced44d22d752f103f377e7b.tar.gz && \
    cd grpc-78ace4cd5dfcc1f2eced44d22d752f103f377e7b && \
    make -j ${NCPU:-4} && \
    make install && \
    ldconfig && rm 78ace4cd5dfcc1f2eced44d22d752f103f377e7b.tar.gz
# ```

# #### googleapis

# We need a recent version of the Google Cloud Platform proto C++ libraries:

# ```bash
WORKDIR /var/tmp/build
RUN wget -q https://github.com/googleapis/cpp-cmakefiles/archive/v0.9.0.tar.gz && \
    tar -xf v0.9.0.tar.gz && \
    cd cpp-cmakefiles-0.9.0 && \
    cmake -DBUILD_SHARED_LIBS=YES -H. -Bcmake-out && \
    cmake --build cmake-out -- -j ${NCPU:-4} && \
    cmake --build cmake-out --target install -- -j ${NCPU:-4} && \
    ldconfig && rm v0.9.0.tar.gz
# ```

# #### googletest

# We need a recent version of GoogleTest to compile the unit and integration
# tests.

# ```bash
WORKDIR /var/tmp/build
RUN wget -q https://github.com/google/googletest/archive/release-1.10.0.tar.gz && \
    tar -xf release-1.10.0.tar.gz && \
    cd googletest-release-1.10.0 && \
    cmake -DCMAKE_BUILD_TYPE="Release" -DBUILD_SHARED_LIBS=yes -H. -Bcmake-out && \
    cmake --build cmake-out -- -j ${NCPU:-4} && \
    cmake --build cmake-out --target install -- -j ${NCPU:-4} && \
    ldconfig && rm release-1.10.0.tar.gz
# ```

FROM devtools AS install
ARG NCPU=4

# #### Compile and install the main project

# We can now compile, test, and install `google-cloud-cpp-common`.

# ```bash
WORKDIR /home/build/project
COPY . /home/build/project
RUN cmake -H. -Bcmake-out
RUN cmake --build cmake-out -- -j "${NCPU:-4}"
WORKDIR /home/build/project/cmake-out
RUN ctest -LE integration-tests --output-on-failure
RUN cmake --build . --target install
# ```

## [END INSTALL.md]

# Verify that the installed files are actually usable
WORKDIR /home/build/test-install-plain-make
COPY ci/test-install /home/build/test-install-plain-make
COPY google/cloud/samples/common_install_test.cc /home/build/test-install-plain-make
RUN make

WORKDIR /home/build/test-install-cmake
COPY ci/test-install /home/build/test-install-cmake
COPY google/cloud/samples/common_install_test.cc /home/build/test-install-cmake
# Always unset PKG_CONFIG_PATH before building with CMake, this is to ensure
# that CMake does not depend on pkg-config to discover the project.
RUN env -u PKG_CONFIG_PATH cmake -H. -B/i
RUN cmake --build /i -- -j "${NCPU:-4}"
