# Copyright (c) 2019 Yubico AB. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

FROM ubuntu:focal
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install --no-install-recommends -y clang-11 cmake git libssl-dev libudev-dev make pkg-config && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN git clone --branch v0.8.0 https://github.com/PJK/libcbor
RUN git clone https://github.com/yubico/libfido2
RUN CC=clang-11 CXX=clang++-11 /libfido2/fuzz/build-coverage /libcbor /libfido2
