# Copyright (c) 2022 Target Brands, Inc. All rights reserved.
#
# Use of this source code is governed by the LICENSE file in this repository.

################################################################################
## docker build --no-cache --target binary -t target/vela-migration:binary .  ##
################################################################################

FROM golang:latest as binary

COPY . /opt/go-vela/community

WORKDIR /opt/go-vela/community

RUN make clean

RUN make build-linux-static

################################################################################
##  docker build --no-cache --target binary -t target/vela-migration:certs .  ##
################################################################################

FROM alpine as certs

RUN apk add --update --no-cache ca-certificates

################################################################################
##  docker build --no-cache --target binary -t target/vela-migration:local .  ##
################################################################################