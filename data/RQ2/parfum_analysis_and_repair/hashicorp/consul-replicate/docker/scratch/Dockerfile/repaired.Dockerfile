#
# Builder
#
FROM golang:1.8 AS builder
LABEL maintainer "Seth Vargo <seth@sethvargo.com> (@sethvargo)"

ARG LD_FLAGS
ARG GOTAGS

WORKDIR "/go/src/github.com/hashicorp/consul-replicate"

COPY . .

RUN \
  CGO_ENABLED="0" \
  go build -a -o "/consul-replicate" -ldflags "${LD_FLAGS}" -tags "${GOTAGS}"

#
# Final
#