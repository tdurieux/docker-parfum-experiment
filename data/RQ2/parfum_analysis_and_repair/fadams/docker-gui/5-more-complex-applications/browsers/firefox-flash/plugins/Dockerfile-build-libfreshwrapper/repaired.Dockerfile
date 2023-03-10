#
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

FROM debian:stretch-slim

# Compile libfreshwrapper-flashplayer.so
RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    ca-certificates git make cmake gcc g++ pkg-config ragel \
    libasound2-dev libpulse-dev libssl-dev libglib2.0-dev \
    libpango1.0-dev libgl1-mesa-dev libevent-dev \
    libgtk2.0-dev libxrandr-dev libxrender-dev libv4l-dev \
    libxcursor-dev libgles2-mesa-dev libavcodec-dev \
    libva-dev libvdpau-dev libdrm-dev libicu-dev && \
    # Actually git clone and build freshplayerplugin
    mkdir /src && cd /src && \
    git clone https://github.com/i-rinat/freshplayerplugin.git && \
    cd freshplayerplugin && mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo .. && \
    make -j"$(nproc)" && \
    cd ../../ && \
    mv freshplayerplugin/build/libfreshwrapper-flashplayer.so . && \
    mv freshplayerplugin/data/freshwrapper.conf.example . && \
    # Remove packages used for compiling libfreshwrapper from the image
    rm -rf freshplayerplugin && \
    apt-get clean && \
    apt-get purge -y ca-certificates git make cmake gcc g++ \
    pkg-config ragel libasound2-dev libpulse-dev libssl-dev \
    libglib2.0-dev libpango1.0-dev libgl1-mesa-dev \
    libevent-dev libgtk2.0-dev libxrandr-dev libxrender-dev \
    libxcursor-dev libv4l-dev libgles2-mesa-dev libicu-dev \
    libavcodec-dev libva-dev libvdpau-dev libdrm-dev && \
    apt-get autoremove -y && \
	rm -rf /var/lib/apt/lists/*

#-------------------------------------------------------------------------------
# 
# To build the image
# docker build -t build-libfreshwrapper -f Dockerfile-build-libfreshwrapper .
#
# To run
# docker run --rm build-libfreshwrapper cat /src/libfreshwrapper-flashplayer.so > libfreshwrapper-flashplayer.so
#
# docker run --rm build-libfreshwrapper cat /src/freshwrapper.conf.example > freshwrapper.conf