#
# Builder
#
FROM docker.mirror.hashicorp.services/golang:1.8 AS builder
LABEL maintainer "Seth Vargo <seth@sethvargo.com> (@sethvargo)"

WORKDIR /go/src/github.com/hashicorp/vault-service-broker

COPY . .

ARG LD_FLAGS=""
ENV LD_FLAGS="${LD_FLAGS}"

RUN \
  CGO_ENABLED="0" \
  GOOS="linux" \
  GOARCH="amd64" \
  go build -a -o "/vault-service-broker" -ldflags "${LD_FLAGS}"

#
# Final
#