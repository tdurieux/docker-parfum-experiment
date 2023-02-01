# Build the manager binary
FROM --platform=$BUILDPLATFORM golang:1.18 as builder

ARG GOARCH=''
ARG GITHUB_PAT=''

WORKDIR /workspace
RUN go install github.com/rakyll/statik@latest

# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum

# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg \
    go mod download

# Copy the go source
COPY cmd/ cmd/
COPY pkg/ pkg/
COPY statik/ statik/
COPY web/ web/
COPY main.go main.go

ARG TARGETOS
ARG TARGETARCH

# Build