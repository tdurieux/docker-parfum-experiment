# Build the manager binary
FROM registry.ci.openshift.org/ocp/builder:rhel-8-golang-1.18-openshift-4.11 AS builder
WORKDIR /go/src/github.com/openshift/cluster-nfd-operator

# Build
COPY . .
RUN make build

# Create production image for running the operator