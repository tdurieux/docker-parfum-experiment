# docker build for IBM Spectrum Scale CSI Operator
FROM --platform=$BUILDPLATFORM golang:1.17 as builder

ARG TARGETOS
ARG TARGETARCH
ARG commit

WORKDIR /workspace
# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum
# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
RUN go mod download

# Copy the go source
COPY main.go main.go
COPY hacks/health_check.go health_check.go
COPY api/ api/
COPY controllers/ controllers/

# Set GOENV to target OS and ARCH
ENV REVISION $commit
ENV GOOS $TARGETOS
ENV GOARCH $TARGETARCH

# Build dummy health checker
RUN CGO_ENABLED=0 go build -ldflags="-X 'main.gitCommit=${REVISION}'" -a -o health_check.sh health_check.go
# Build CSI Operator
RUN CGO_ENABLED=0 go build -ldflags="-X 'main.gitCommit=${REVISION}'" -a -o manager main.go

# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details