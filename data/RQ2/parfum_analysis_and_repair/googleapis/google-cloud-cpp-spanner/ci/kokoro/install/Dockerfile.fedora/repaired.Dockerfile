# Copyright 2019 Google LLC
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

ARG DISTRO_VERSION=30
FROM fedora:${DISTRO_VERSION} AS devtools
ARG NCPU=4

## [START INSTALL.md]

# Install the minimal development tools:

# ```bash
RUN dnf makecache && \
    dnf install -y cmake gcc-c++ git make openssl-devel pkgconfig \
        zlib-devel
# ```

# Fedora 30 includes packages for gRPC, libcurl, and OpenSSL that are recent
# enough for the project. Install these packages and additional development
# tools to compile the dependencies:

# ```bash
RUN dnf makecache && \
    dnf install -y grpc-devel grpc-plugins \
        libcurl-devel protobuf-compiler tar wget zlib-devel
# ```

# The following steps will install libraries and tools in `/usr/local`. By
# default pkg-config does not search in these directories.

# ```bash
ENV PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig
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

# #### google-cloud-cpp-common

# The project also depends on google-cloud-cpp-common, the libraries shared by
# all the Google Cloud C++ client libraries:

# ```bash
WORKDIR /var/tmp/build
RUN wget -q https://github.com/googleapis/google-cloud-cpp-common/archive/v0.25.0.tar.gz && \
    tar -xf v0.25.0.tar.gz && \
    cd google-cloud-cpp-common-0.25.0 && \
    cmake -H. -Bcmake-out -DBUILD_TESTING=OFF && \
    cmake --build cmake-out -- -j ${NCPU:-4} && \
    cmake --build cmake-out --target install -- -j ${NCPU:-4} && \
    ldconfig && rm v0.25.0.tar.gz
# ```

FROM devtools AS install

# #### Compile and install the main project

# We can now compile, test, and install `google-cloud-cpp-spanner`.

# ```bash
WORKDIR /home/build/project
COPY . /home/build/project
RUN cmake -H. -Bcmake-out -DBUILD_TESTING=OFF -DCMAKE_BUILD_TYPE=Release
RUN cmake --build cmake-out -- -j "${NCPU:-4}"
RUN cmake --build cmake-out --target install
# ```

## [END INSTALL.md]

ENV PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig

# Verify that the installed files are actually usable
WORKDIR /home/build/test-install-cmake
COPY google/cloud/spanner/quickstart /home/build/test-install-cmake
# Disable pkg-config with CMake to verify it is not used in package discovery.
RUN env -u PKG_CONFIG_PATH cmake -H. -B/i
RUN cmake --build /i -- -j "${NCPU:-4}"
