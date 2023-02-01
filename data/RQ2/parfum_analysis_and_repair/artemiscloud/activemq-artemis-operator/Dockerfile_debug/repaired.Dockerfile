# Build the manager binary
FROM golang:1.16 as builder

ENV GOOS=linux
ENV CGO_ENABLED=0
ENV BROKER_NAME=activemq-artemis

RUN go get github.com/go-delve/delve/cmd/dlv
RUN mkdir -p /tmp/activemq-artemis-operator

WORKDIR /workspace
# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum
# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
RUN go mod download

# Copy the go source
COPY main.go main.go
COPY api/ api/
COPY controllers/ controllers/
COPY pkg/ pkg/
COPY version/ version/
COPY entrypoint/ entrypoint/

# Build