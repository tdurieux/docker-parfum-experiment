#/*************************************************************************
# * Copyright (C) [2021] by Cambricon, Inc. All rights reserved
# *
# *  Licensed under the Apache License, Version 2.0 (the "License");
# *  you may not use this file except in compliance with the License.
# *  You may obtain a copy of the License at
# *
# *     http://www.apache.org/licenses/LICENSE-2.0
# *
# * The above copyright notice and this permission notice shall be included in
# * all copies or substantial portions of the Software.
# * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# * THE SOFTWARE.
# *************************************************************************/

# 1. build image:
#   docker build -f Dockerfile.devel.18.04 -t cnstream:latest .
# 2. start container:
#   docker run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY -e GDK_SCALE -e GDK_DPI_SCALE --privileged -v /dev:/dev --net=host --ipc=host --pid=host -it --name container_name cnstream:latest

FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -i "1i deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse\n deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse\n deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse\n deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse\n deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse\n deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse\n deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse\n deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse\n deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse\n deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse\n" /etc/apt/sources.list && \
    apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends apt-utils \
            git build-essential cmake make vim curl libcurl4-openssl-dev \
            libopencv-dev \
            libsdl2-dev \
            libfreetype6 \
            ttf-wqy-zenhei \
            wget \
            python3-pip \
            python3-dev \
            mediainfo \
            libgflags-dev \
            libgoogle-glog-dev \
            openssh-server \
            librdkafka-dev \
            lcov  \
            ca-certificates \
            net-tools && \
    pip3 install --no-cache-dir virtualenv && \
    pip3 install --no-cache-dir setuptools && \
    ln -sf /usr/bin/python3 /usr/bin/python && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
