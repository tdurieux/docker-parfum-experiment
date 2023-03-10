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

# Install the minimal packages needed to compile libcxx, install Bazel, and
# then compile our code.
RUN dnf makecache && \
    dnf install -y clang clang-tools-extra cmake gcc-c++ git llvm-devel \
        make ninja-build python3-lit tar unzip which wget xz

WORKDIR /var/tmp/build
RUN wget -q https://releases.llvm.org/8.0.0/libcxx-8.0.0.src.tar.xz
RUN tar -xf libcxx-8.0.0.src.tar.xz && rm libcxx-8.0.0.src.tar.xz
RUN wget -q https://releases.llvm.org/8.0.0/libcxxabi-8.0.0.src.tar.xz
RUN tar -xf libcxxabi-8.0.0.src.tar.xz && rm libcxxabi-8.0.0.src.tar.xz

# To build libc++abi we need to bootstrap libc++ without libc++abi first:
RUN cmake -Hlibcxx-8.0.0.src -B.boot-libcxx -GNinja -Wno-dev \
    -DLLVM_USE_SANITIZER=Memory -DLLVM_EXTERNAL_LIT=/usr/bin/lit \
    -DLLVM_CONFIG_PATH=/usr/bin/llvm-config \
    -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release  \
    -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_COMPILER=clang
RUN cmake --build .boot-libcxx --target cxx
RUN cmake --build .boot-libcxx --target install-cxx

# Compile libc++abi using the bootstrap version
RUN cmake -Hlibcxxabi-8.0.0.src -B.build-libcxxabi -GNinja -Wno-dev \
    -DLIBCXXABI_LIBCXX_PATH=/var/tmp/build/libcxx-8.0.0.src \
    -DLLVM_USE_SANITIZER=Memory -DLLVM_EXTERNAL_LIT=/usr/bin/lit \
    -DLLVM_CONFIG_PATH=/usr/bin/llvm-config \
    -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release  \
    -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_COMPILER=clang
RUN cmake --build .build-libcxxabi --target check-cxxabi
RUN cmake --build .build-libcxxabi --target install-cxxabi

# After libc++abi is installed, compile test and install the libc++ library
# again.
RUN cmake -Hlibcxx-8.0.0.src -B.build-libcxx -GNinja -Wno-dev \
    -DLIBCXX_CXX_ABI=libcxxabi \
    -DLIBCXX_CXX_ABI_INCLUDE_PATHS=/var/tmp/build/libcxxabi-8.0.0.src/include \
    -DLLVM_USE_SANITIZER=Memory -DLLVM_EXTERNAL_LIT=/usr/bin/lit \
    -DLLVM_CONFIG_PATH=/usr/bin/llvm-config \
    -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release  \
    -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_COMPILER=clang
# The tests for libcxx do not pass, mostly around the filesystem library, which
# we do not care about.
RUN cmake --build .build-libcxx --target cxx
RUN cmake --build .build-libcxx --target install-cxx

WORKDIR /var/tmp/ci
COPY . /var/tmp/ci
RUN /var/tmp/ci/install-bazel.sh
