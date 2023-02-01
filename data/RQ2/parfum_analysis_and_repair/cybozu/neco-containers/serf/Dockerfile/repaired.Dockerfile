# serf container

# Stage1: build from source
FROM quay.io/cybozu/golang:1.17-focal AS build

ARG SERF_VERSION=0.9.7

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN mkdir -p /go/src/github.com/hashicorp/serf \
&& curl -fsSL https://github.com/hashicorp/serf/archive/v${SERF_VERSION}.tar.gz | \
tar -x -z -f - --strip-components 1 -C /go/src/github.com/hashicorp/serf

WORKDIR /go/src/github.com/hashicorp/serf

RUN go install -ldflags="-w -s" ./...

# Stage2: setup runtime container