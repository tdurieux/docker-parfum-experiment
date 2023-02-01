# Build the manager binary
FROM --platform=$BUILDPLATFORM golang:1.18 as builder
ARG TARGETARCH

WORKDIR /workspace
# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum
# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
RUN go mod download

# Copy the go source
COPY . .

# Build
RUN GOOS=linux GOARCH=$TARGETARCH make build/ansible-operator

# Final image.
# TODO(asmacdo) update GH action to set this
FROM quay.io/operator-framework/ansible-operator-2.11-preview-base:master-f34c12d88b2e889c86a19418dd9ad2ad4e027256

ENV HOME=/opt/ansible \
    USER_NAME=ansible \
    USER_UID=1001

# Ensure directory permissions are properly set