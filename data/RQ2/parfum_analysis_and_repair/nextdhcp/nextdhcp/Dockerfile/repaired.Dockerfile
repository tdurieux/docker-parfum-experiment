# Build Stage
FROM golang:1.16

ENV GOPATH /go
ENV GOBIN /go/bin
WORKDIR /go/src/github.com/nextdhcp

COPY . .
RUN make build

# Release Stage