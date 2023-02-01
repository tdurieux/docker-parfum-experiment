# Copyright 2022 The Kubernetes Authors.
# SPDX-License-Identifier: Apache-2.0

FROM alpine:latest

ENV BUILD_HOME=/usr/local/build
RUN apk update && apk add --no-cache git nodejs npm
RUN npm install -g typescript && npm cache clean --force;

RUN mkdir -p $BUILD_HOME

WORKDIR $BUILD_HOME

RUN git clone https://github.com/GoogleContainerTools/kpt-functions-sdk.git .
RUN git checkout tags/release-kpt-functions-v0.14.2
WORKDIR $BUILD_HOME/ts/hello-world/
RUN npm install && npm cache clean --force;
RUN npm run build
