# Copyright 2019 The Kubernetes Authors All rights reserved.
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

FROM ubuntu:20.04

ARG GO_VERSION

RUN apt update

RUN echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports focal main universe multiverse" >> /etc/apt/sources.list && \
    echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports focal-updates main universe restricted multiverse" >> /etc/apt/sources.list && \
    dpkg --add-architecture arm64 && \
    (apt update || true)

RUN DEBIAN_FRONTEND=noninteractive \
    apt --no-install-recommends install \
    -o APT::Immediate-Configure=false -y \
    gcc-aarch64-linux-gnu \
    make \
    pkg-config \
    curl \
    libvirt-dev:arm64 && \
    dpkg --configure -a && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sSL https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz | tar -C /usr/local -xzf -

ENV GOPATH /go

ENV CC=aarch64-linux-gnu-gcc
ENV CGO_ENABLED=1
ENV PKG_CONFIG_PATH=/usr/lib/aarch64-linux-gnu/pkgconfig
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin:/go/bin
