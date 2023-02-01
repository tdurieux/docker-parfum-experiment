# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0

ARG GO_VER
ARG ALPINE_VER
FROM golang:${GO_VER}-alpine as golang

RUN apk add --no-cache \
	bash \
	gcc \
	git \
	make \
	musl-dev;

ADD . $GOPATH/src/github.com/hyperledger/fabric
WORKDIR $GOPATH/src/github.com/hyperledger/fabric

FROM golang as tools
RUN make configtxgen configtxlator cryptogen peer discover idemixgen

FROM golang:${GO_VER}-alpine
# git is required to support `go list -m`