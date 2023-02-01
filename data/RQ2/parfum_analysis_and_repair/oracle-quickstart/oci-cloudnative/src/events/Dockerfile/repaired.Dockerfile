#
# Copyright (c) 2020, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 
FROM golang:1.13-alpine AS go-builder
RUN apk add --no-cache ca-certificates git
WORKDIR /src
COPY *.go ./
COPY go.* ./
COPY cmd cmd

# Build service
RUN GO111MODULE=on GOARCH=amd64 CGO_ENABLED=0 GOOS=linux \
    go build -a \
    -installsuffix cgo \
    -o /app cmd/main.go

# Create runtime