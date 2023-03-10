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

ARG DISTRO_VERSION=31
FROM fedora:${DISTRO_VERSION}
ARG NCPU=4

# Fedora includes packages for gRPC, libcurl, and OpenSSL that are recent enough
# for `google-cloud-cpp`. Install these packages and additional development
# tools to compile the dependencies:
RUN dnf makecache && \
    dnf install -y abi-compliance-checker abi-dumper \
        clang clang-tools-extra cmake diffutils doxygen findutils gcc-c++ git \
        grpc-devel grpc-plugins libcxx-devel libcxxabi-devel libcurl-devel \
        make openssl-devel pkgconfig protobuf-compiler python3 python3-pip \
        ShellCheck tar unzip w3m wget which zlib-devel

# Install the the buildifier tool, which does not compile with the default
# golang compiler for Ubuntu 16.04 and Ubuntu 18.04.
RUN wget -q -O /usr/bin/buildifier https://github.com/bazelbuild/buildtools/releases/download/0.29.0/buildifier
RUN chmod 755 /usr/bin/buildifier

# Install cmake_format to automatically format the CMake list files.
#     https://github.com/cheshirekow/cmake_format
# Pin this to an specific version because the formatting changes when the
# "latest" version is updated, and we do not want the builds to break just
# because some third party changed something.
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir cmake_format==0.6.8

# Install googletest, remove the downloaded files and the temporary artifacts
# after a successful build to keep the image smaller (and with fewer layers)
WORKDIR /var/tmp/build
RUN wget -q https://github.com/google/googletest/archive/release-1.10.0.tar.gz && \
    tar -xf release-1.10.0.tar.gz && \
    cd /var/tmp/build/googletest-release-1.10.0 && \
    cmake \
      -DCMAKE_BUILD_TYPE="Release" \
      -DBUILD_SHARED_LIBS=yes \
      -H. -Bcmake-out/googletest && \
    cmake --build cmake-out/googletest --target install -- -j ${NCPU} && \
    ldconfig && \
    cd /var/tmp && rm -fr build && rm release-1.10.0.tar.gz

# Install googletest, remove the downloaded files and the temporary artifacts
# after a successful build to keep the image smaller (and with fewer layers)
WORKDIR /var/tmp/build
RUN wget -q https://github.com/googleapis/cpp-cmakefiles/archive/v0.9.0.tar.gz && \
    tar -xf v0.9.0.tar.gz && \
    cd /var/tmp/build/cpp-cmakefiles-0.9.0 && \
    cmake \
      -DBUILD_SHARED_LIBS=YES \
      -H. -Bcmake-out && \
    cmake --build cmake-out --target install -- -j ${NCPU} && \
    ldconfig && \
    cd /var/tmp && rm -fr build && rm v0.9.0.tar.gz

# Install Bazel because some of the builds need it.
WORKDIR /var/tmp/ci
COPY . /var/tmp/ci
RUN /var/tmp/ci/install-bazel.sh
