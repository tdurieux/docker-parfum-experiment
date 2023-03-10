# -*- mode: dockerfile -*-
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
#
# Dockerfile to build MXNet for Android ARM64/ARMv8

FROM dockcross/base:latest
MAINTAINER Pedro Larroy "pllarroy@amazon.com"

# The cross-compiling emulator
RUN apt-get update && apt-get install --no-install-recommends -y \
  qemu-user \
  qemu-user-static \
  unzip && rm -rf /var/lib/apt/lists/*;

ENV CROSS_TRIPLE=aarch64-linux-android
ENV CROSS_ROOT=/usr/${CROSS_TRIPLE}
ENV AS=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-as \
    AR=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-ar \
    CC=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-gcc \
    CPP=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-cpp \
    CXX=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-g++ \
    LD=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-ld


ENV DEFAULT_DOCKCROSS_IMAGE dockcross/android-arm

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG IMAGE
ARG VCS_REF
ARG VCS_URL
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name=$IMAGE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.schema-version="1.0"

ENV ARCH aarch64

ENV CC=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-clang
ENV CXX=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-clang++

WORKDIR /work/deps
COPY install/android_arm64_ndk.sh /work/
RUN /work/android_arm64_ndk.sh
COPY install/android_arm64_openblas.sh /work/
RUN /work/android_arm64_openblas.sh
ENV CPLUS_INCLUDE_PATH /work/deps/OpenBLAS
WORKDIR /work/build

COPY runtime_functions.sh /work/
