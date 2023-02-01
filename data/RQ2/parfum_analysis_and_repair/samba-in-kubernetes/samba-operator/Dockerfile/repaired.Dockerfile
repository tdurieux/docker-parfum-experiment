# Build the manager binary
FROM docker.io/golang:1.18 as builder
ARG GIT_VERSION="(unset)"
ARG COMMIT_ID="(unset)"
ARG ARCH=""

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
COPY internal/ internal/

# Build