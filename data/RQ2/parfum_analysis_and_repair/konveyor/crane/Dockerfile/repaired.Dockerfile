# Build the manager binary
FROM registry.ci.openshift.org/openshift/release:golang-1.17 as builder
ENV GOFLAGS "-mod=mod"
WORKDIR /go/src/github.com/konveyor/crane

# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum
# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer