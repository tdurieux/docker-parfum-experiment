# Copyright 2019 The Kubernetes Authors.
# SPDX-License-Identifier: Apache-2.0

FROM golang:1.18-stretch
ENV CGO_ENABLED=0
WORKDIR /go/src/

# download modules