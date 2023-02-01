# Copyright (c) 2019 Zededa, Inc.
# SPDX-License-Identifier: Apache-2.0

FROM lfedge/eve-alpine:6.2.0 AS build
ENV BUILD_PKGS go git
RUN eve-alpine-deploy.sh

# FIXME: integrate go 1.16 into eve-alpine
RUN apk --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.14/community add -U --upgrade go &&\
    go version

ENV CGO_ENABLED=0
ENV GO111MODULE=on

RUN mkdir -p /adam/src && mkdir -p /adam/bin
WORKDIR /adam/src
RUN go install github.com/go-swagger/go-swagger/cmd/swagger@v0.27.0
COPY go.mod .
COPY go.sum .
RUN go mod download

# these have to be last steps so they do not bust the cache with each change
COPY . /adam/src

ARG GOOS=linux
# ARG GOARCH=amd64