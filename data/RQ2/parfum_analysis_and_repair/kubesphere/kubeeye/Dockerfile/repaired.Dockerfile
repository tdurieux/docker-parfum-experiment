# Build the manager binary
FROM golang:1.17 as builder

WORKDIR /workspace

COPY apis/ apis/
COPY client/ client/
COPY cmd/ cmd/
COPY controllers/ controllers/
COPY pkg/ pkg/
COPY plugins/ plugins/

# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum

RUN go mod tidy && go mod vendor

ENV CGO_ENABLED=0

# Build