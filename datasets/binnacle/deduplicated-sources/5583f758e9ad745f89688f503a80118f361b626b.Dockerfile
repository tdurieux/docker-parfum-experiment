# Copyright 2016 The Kubernetes Authors All rights reserved.
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

FROM ubuntu:16.04

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -qqy \
        apt-transport-https \
        ca-certificates \
        wget \
        curl \
        lxc \
        iptables \
        ipcalc \
        ethtool \
        dmsetup \
        iproute2 \
        net-tools \
        iputils-ping \
        tcpdump \
        && \
    apt-get clean

# Install specific Docker version
ENV DOCKER_VERSION 1.11.2-0~xenial
#ENV DOCKER_VERSION 1.12.1-0~xenial
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
    mkdir -p /etc/apt/sources.list.d && \
    echo deb https://apt.dockerproject.org/repo ubuntu-xenial main > /etc/apt/sources.list.d/docker.list && \
    apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -qqy \
        docker-engine=${DOCKER_VERSION} \
        && \
    apt-get clean

RUN curl -o- https://raw.githubusercontent.com/karlkfi/resolveip/v1.0.2/install.sh | bash

COPY ./bin/* /usr/local/bin/
RUN mkdir -p /var/lib/kubelet/manifests
