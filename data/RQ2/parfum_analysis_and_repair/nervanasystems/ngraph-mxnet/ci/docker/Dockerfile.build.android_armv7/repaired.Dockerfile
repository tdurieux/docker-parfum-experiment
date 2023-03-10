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
# Dockerfile to build MXNet for Android ARMv7

FROM mxnetcipinned/dockcross-base:11262018
MAINTAINER Pedro Larroy "pllarroy@amazon.com"

# The cross-compiling emulator
RUN apt-get update && apt-get install --no-install-recommends -y \
  unzip && rm -rf /var/lib/apt/lists/*;

ENV CROSS_TRIPLE=arm-linux-androideabi
ENV CROSS_ROOT=/usr/${CROSS_TRIPLE}
ENV AS=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-as \
    AR=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-ar \
    CC=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-gcc \
    CPP=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-cpp \
    CXX=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-g++ \
    LD=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-ld

ENV ANDROID_NDK_REVISION 17b
ENV ANDROID_NDK_API 27
ENV ANDROID_NDK_ARCH arm
WORKDIR /work/deps
COPY install/android_ndk.sh /work/deps
RUN /work/deps/android_ndk.sh

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


ENV CC=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-clang
ENV CXX=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-clang++

WORKDIR /work/deps

COPY install/deb_ubuntu_ccache.sh /work/
RUN /work/deb_ubuntu_ccache.sh
WORKDIR /work
COPY install/ubuntu_arm.sh /work/
RUN /work/ubuntu_arm.sh

COPY install/arm_openblas.sh /work/
COPY install/android_armv7_openblas.sh /work/deps
RUN /work/deps/android_armv7_openblas.sh

ENV OpenBLAS_HOME=${CROSS_ROOT}
ENV OpenBLAS_DIR=${CROSS_ROOT}

WORKDIR /work

ARG USER_ID=0
ARG GROUP_ID=0
COPY install/ubuntu_adduser.sh /work/
RUN /work/ubuntu_adduser.sh

COPY runtime_functions.sh /work/
WORKDIR /work/mxnet

