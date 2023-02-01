# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2021 Intel Corporation

FROM ubuntu:18.04

ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy
ARG binaries_path

RUN apt-get update && \
    apt-get install --no-install-recommends -y kmod iputils-ping vim iproute2 screen && \
    apt-get install --no-install-recommends -y tcpdump ethtool net-tools fakeroot libsctp-dev lksctp-tools sudo python && rm -rf /var/lib/apt/lists/*;

WORKDIR /root

COPY $binaries_path ./amf-smf
COPY ./run-smf-smf.sh ./amf-smf

