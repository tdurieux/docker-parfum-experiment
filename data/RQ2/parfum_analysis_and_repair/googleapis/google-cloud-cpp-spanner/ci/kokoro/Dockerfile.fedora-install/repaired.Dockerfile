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

ARG DISTRO_VERSION=30
FROM fedora:${DISTRO_VERSION}

# Fedora includes packages for gRPC, libcurl, and OpenSSL that are recent enough
# for `google-cloud-cpp`. Install these packages and additional development
# tools to compile the dependencies:
RUN dnf makecache && \
    dnf install -y abi-compliance-checker abi-dumper \
        clang clang-tools-extra cmake diffutils doxygen findutils gcc-c++ git \
        grpc-devel grpc-plugins libcxx-devel libcxxabi-devel libcurl-devel \
        make openssl-devel pkgconfig protobuf-compiler \
        python3 python3-pip ShellCheck \
        tar w3m wget zlib-devel

# Install the the buildifier tool, which does not compile with the default
# golang compiler for Ubuntu 16.04 and Ubuntu 18.04.
RUN wget -q -O /usr/bin/buildifier https://github.com/bazelbuild/buildtools/releases/download/0.17.2/buildifier
RUN chmod 755 /usr/bin/buildifier

# Install cmake_format to automatically format the CMake list files.
#     https://github.com/cheshirekow/cmake_format
# Pin this to an specific version because the formatting changes when the
# "latest" version is updated, and we do not want the builds to break just
# because some third party changed something.
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir setuptools cmake_format==0.6.8

# Download and compile googletest, we need a recent version.
WORKDIR /var/tmp/build
RUN wget -q https://github.com/google/googletest/archive/release-1.10.0.tar.gz
RUN tar -xf release-1.10.0.tar.gz && rm release-1.10.0.tar.gz
WORKDIR /var/tmp/build/googletest-release-1.10.0
RUN cmake \
          -DBUILD_SHARED_LIBS=yes \
          -H. -Bcmake-out/gtest
RUN cmake --build cmake-out/gtest --target install -- -j $(nproc)

# Download and compile Google microbenchmark support library:
WORKDIR /var/tmp/build
RUN wget -q https://github.com/google/benchmark/archive/v1.5.0.tar.gz
RUN tar -xf v1.5.0.tar.gz && rm v1.5.0.tar.gz
WORKDIR /var/tmp/build/benchmark-1.5.0
RUN cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_SHARED_LIBS=yes \
        -DBENCHMARK_ENABLE_TESTING=OFF \
        -H. -Bcmake-out/benchmark
RUN cmake --build cmake-out/benchmark --target install -- -j $(nproc)

# Download and compile googleapis/cpp-cmakefiles:
WORKDIR /var/tmp/build
RUN wget -q https://github.com/googleapis/cpp-cmakefiles/archive/v0.9.0.tar.gz
RUN tar -xf v0.9.0.tar.gz && rm v0.9.0.tar.gz
WORKDIR /var/tmp/build/cpp-cmakefiles-0.9.0
# Compile without the tests because we are testing spanner, not the base
# libraries
RUN cmake -H. -Bcmake-out \
    -DBUILD_SHARED_LIBS=yes \
    -DBUILD_TESTING=OFF \
    -DGOOGLE_CLOUD_CPP_TESTING_UTIL_ENABLE_INSTALL=ON
RUN cmake --build cmake-out -- -j $(nproc)
RUN cmake --build cmake-out --target install

# Download and compile google-cloud-cpp from source too:
WORKDIR /var/tmp/build
RUN wget -q https://github.com/googleapis/google-cloud-cpp-common/archive/v0.25.0.tar.gz && \
    tar -xf v0.25.0.tar.gz && \
    cd /var/tmp/build/google-cloud-cpp-common-0.25.0 && \
    cmake -H. -Bcmake-out \
      -DBUILD_SHARED_LIBS=YES \
      -DBUILD_TESTING=OFF \
      -DGOOGLE_CLOUD_CPP_TESTING_UTIL_ENABLE_INSTALL=ON && \
    cmake --build cmake-out --target install -- -j ${NCPU} && \
    ldconfig && \
    cd /var/tmp && rm -fr build && rm v0.25.0.tar.gz
