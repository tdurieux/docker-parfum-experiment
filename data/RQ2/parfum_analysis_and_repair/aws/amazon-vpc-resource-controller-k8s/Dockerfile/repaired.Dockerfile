# Build the controller binary
FROM public.ecr.aws/docker/library/golang:1.17.7 as builder

WORKDIR /workspace
ENV GOPROXY direct

# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum
# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
RUN go mod download

# Copy the go source
COPY .git/ .git/
COPY main.go main.go
COPY apis/ apis/
COPY pkg/ pkg/
COPY controllers/ controllers/
COPY webhooks/ webhooks/

# Version package for passing the ldflags
ENV VERSION_PKG=github.com/aws/amazon-vpc-resource-controller-k8s/pkg/version
# Build