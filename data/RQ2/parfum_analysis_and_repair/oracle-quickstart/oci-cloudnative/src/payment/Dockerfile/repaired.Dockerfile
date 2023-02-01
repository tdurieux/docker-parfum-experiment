#
# Copyright (c) 2021, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

##### Go Builder image
FROM --platform=${TARGETPLATFORM:-linux/amd64} golang:1.16 AS go-builder

ARG TARGETOS
ARG TARGETARCH

# Payment Go Source
WORKDIR /go/src/mushop/payment
COPY cmd/*.go cmd/
COPY *.go .
COPY go.mod .
COPY go.sum .

# Build Payment service
RUN GOARCH=${TARGETARCH:-amd64} CGO_ENABLED=0 GOOS=${TARGETOS:-linux} \
    go build -a \
    -installsuffix cgo \
    -o /payment cmd/main.go

##### Payment Service Image