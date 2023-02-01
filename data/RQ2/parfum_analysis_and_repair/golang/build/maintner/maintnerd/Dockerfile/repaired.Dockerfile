# Copyright 2017 The Go Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

FROM golang:1.17 AS build
LABEL maintainer="golang-dev@googlegroups.com"

RUN mkdir /gocache
ENV GOCACHE /gocache

COPY go.mod /go/src/golang.org/x/build/go.mod
COPY go.sum /go/src/golang.org/x/build/go.sum

WORKDIR /go/src/golang.org/x/build

# Optimization for iterative docker build speed, not necessary for correctness:
# TODO: write a tool to make writing Go module-friendly Dockerfiles easier.
RUN go install cloud.google.com/go/compute/metadata
RUN go install cloud.google.com/go/storage
RUN go install golang.org/x/crypto/acme/autocert
RUN go install golang.org/x/net/http2
RUN go install golang.org/x/time/rate
RUN go install google.golang.org/grpc

COPY . /go/src/golang.org/x/build/

RUN go install golang.org/x/build/maintner/maintnerd


FROM debian:buster
LABEL maintainer="golang-dev@googlegroups.com"

# For interacting with the Go source & subrepos
RUN apt-get update && apt-get install -y \
	--no-install-recommends \
	ca-certificates \
	dirmngr \
	git-core \
	gnupg \
	netbase \
	openssh-client \
	tini \
	&& rm -rf /var/lib/apt/lists/*

# Add Github.com's known_hosts entries, so git push calls later don't
# prompt, and don't need to have their strict host key checking
# disabled.