# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

FROM arm64v8/ubuntu:20.04

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive
ENV GO_TAG=go1.18.3

# required dependencies for building/testing
RUN apt-get update
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gnupg && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y dieharder && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y lcov && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

# developement niceties
RUN apt-get install --no-install-recommends -y ninja-build && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# fetch corretto repo
RUN curl -f -s https://apt.corretto.aws/corretto.key | apt-key add -
RUN echo 'deb https://apt.corretto.aws stable main' | tee /etc/apt/sources.list.d/corretto.list
RUN apt-get update

# AWS-LC FIPS requires golang.
RUN cd /tmp && \
    wget https://dl.google.com/go/$GO_TAG.linux-arm64.tar.gz && \
    tar -xvf $GO_TAG.linux-arm64.tar.gz && \
    mv go /usr/local && \
    rm -rf /tmp/* && rm $GO_TAG.linux-arm64.tar.gz

ENV GOROOT=/usr/local/go
ENV GO111MODULE=on
ENV PATH="$GOROOT/bin:$PATH"
