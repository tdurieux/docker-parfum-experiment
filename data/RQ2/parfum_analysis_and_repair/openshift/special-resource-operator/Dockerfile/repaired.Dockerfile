# Build the manager binary
FROM registry.ci.openshift.org/ocp/builder:rhel-8-golang-1.18-openshift-4.11 AS builder

WORKDIR /workspace

# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum

COPY hack/ hack/
COPY helm-plugins/ helm-plugins/
COPY Makefile.specialresource.mk Makefile.specialresource.mk
COPY Makefile.helper.mk Makefile.helper.mk
COPY Makefile Makefile
COPY scripts/ scripts/

# Copy the go source