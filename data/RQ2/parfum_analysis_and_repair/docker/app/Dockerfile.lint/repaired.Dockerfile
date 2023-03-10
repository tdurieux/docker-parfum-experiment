ARG ALPINE_VERSION=3.11
ARG GO_VERSION=1.13.10

FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION}
RUN apk add --no-cache \
    curl \
    git \
    make \
    coreutils \
    build-base

RUN GO111MODULE=on go get \
    github.com/golangci/golangci-lint/cmd/golangci-lint@v1.23.0 \
    && rm -rf /go/src/* /go/pkg/*

WORKDIR /go/src/github.com/docker/app
ENV CGO_ENABLED=0

COPY . .