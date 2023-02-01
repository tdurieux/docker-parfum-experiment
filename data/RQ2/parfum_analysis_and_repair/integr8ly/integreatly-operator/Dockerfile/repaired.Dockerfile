# Build the manager binary
FROM registry.ci.openshift.org/openshift/release:golang-1.18 AS builder

WORKDIR /workspace
# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum
COPY vendor/ vendor/

# Copy the go source
COPY main.go main.go
COPY apis/ apis/
COPY apis-products/ apis-products/
COPY controllers/ controllers/
COPY pkg/ pkg/
COPY version/ version/
COPY test/ test/

# Build