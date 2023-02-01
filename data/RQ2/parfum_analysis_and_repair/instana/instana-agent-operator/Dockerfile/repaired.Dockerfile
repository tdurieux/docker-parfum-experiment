#
# (c) Copyright IBM Corp. 2021
# (c) Copyright Instana Inc.
#

# Build the manager binary, always build on amd64 platform
FROM --platform=linux/amd64 golang:1.18 as builder

ARG TARGETPLATFORM='linux/amd64'
ARG VERSION=dev
ARG GIT_COMMIT=unspecified

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
COPY version/ version/

# Build, injecting VERSION and GIT_COMMIT directly in the code
RUN export ARCH=$(case "${TARGETPLATFORM}" in 'linux/amd64') echo 'amd64' ;; 'linux/arm64') echo 'arm64' ;; 'linux/s390x') echo 's390x' ;; 'linux/ppc64le') echo 'ppc64le' ;; esac) \
    && CGO_ENABLED=0 GOOS=linux GOARCH="${ARCH}" GO111MODULE=on \
	go build -ldflags="-X 'github.com/instana/instana-agent-operator/version.Version=${VERSION}' -X 'github.com/instana/instana-agent-operator/version.GitCommit=${GIT_COMMIT}'" -a -o manager main.go

# Resulting image with actual Operator