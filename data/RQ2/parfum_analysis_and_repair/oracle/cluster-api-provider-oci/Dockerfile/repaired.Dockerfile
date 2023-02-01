# Build the manager binary
FROM golang:1.17.3 as builder

WORKDIR /workspace
# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum

ARG package=.
ARG ARCH
ARG LDFLAGS

# Copy the go source
COPY main.go main.go
COPY api/ api/
COPY controllers/ controllers/
COPY cloud/ cloud/
COPY exp/ exp/
COPY feature/ feature/
COPY vendor/ vendor/

# Build