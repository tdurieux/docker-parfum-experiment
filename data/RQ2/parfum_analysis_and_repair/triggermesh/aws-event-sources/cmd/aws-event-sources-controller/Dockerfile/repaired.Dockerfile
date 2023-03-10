# Copyright (c) 2020 TriggerMesh Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM golang:1.15-buster AS builder

ENV CGO_ENABLED 0
ENV GOOS linux
ENV GOARCH amd64

WORKDIR /go/src/aws-event-sources-controller

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN BIN_OUTPUT_DIR=/bin make aws-event-sources-controller && \
    mkdir /kodata && \
    mv .git/* /kodata/ && \
    rm -rf ${GOPATH} && \
    rm -rf ${HOME}/.cache

FROM registry.access.redhat.com/ubi8/ubi-minimal

ARG VERSION

LABEL name "AWS Event Sources Controller"
LABEL vendor "TriggerMesh Inc."
LABEL version "$VERSION"
LABEL release "1"
LABEL summary "AWS Event Sources controller for Kubernetes"
LABEL description "aws-event-sources is a Kubernetes controller that implements Knative event sources for AWS services"

# Emulate ko builds
# https://github.com/google/ko/blob/v0.5.0/README.md#including-static-assets