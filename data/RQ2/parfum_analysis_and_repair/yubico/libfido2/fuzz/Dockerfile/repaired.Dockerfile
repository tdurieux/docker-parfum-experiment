# Copyright (c) 2019-2022 Yubico AB. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

FROM alpine:latest
ENV CC=clang
ENV CXX=clang++
RUN apk -q update
RUN apk add --no-cache build-base clang clang-analyzer cmake compiler-rt coreutils
RUN apk add --no-cache eudev-dev git linux-headers llvm openssl-dev pcsc-lite-dev
RUN apk add --no-cache sudo tar zlib-dev
RUN git clone --branch v0.9.0 --depth=1 https://github.com/PJK/libcbor
RUN git clone --depth=1 https://github.com/yubico/libfido2
WORKDIR /libfido2
RUN ./fuzz/build-coverage /libcbor /libfido2
