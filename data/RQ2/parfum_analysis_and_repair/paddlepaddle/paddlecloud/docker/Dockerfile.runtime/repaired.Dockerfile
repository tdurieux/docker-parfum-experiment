# Build the manager binary
FROM golang:1.17 as builder

WORKDIR /workspace
# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum

ENV GOPROXY="https://goproxy.cn,direct"
# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
RUN go mod download

# Copy the go source
COPY cmd/runtime/main.go main.go
COPY pkg/ pkg/

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a -o nuwa main.go

# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM bitnami/minideb:stretch
WORKDIR /

ENV JUICEFS_PATH=/usr/bin/juicefs

RUN apt-get update && apt-get install --no-install-recommends -y wget curl && \
    JFS_LATEST_TAG=$( curl -f -s https://api.github.com/repos/juicedata/juicefs/releases/latest | grep 'tag_name' | cut -d '"' -f 4 | tr -d 'v') && \
    wget "https://github.com/juicedata/juicefs/releases/download/v${JFS_LATEST_TAG}/juicefs-${JFS_LATEST_TAG}-linux-amd64.tar.gz" && \
    tar xzf juicefs-${JFS_LATEST_TAG}-linux-amd64.tar.gz && rm -rf README.md README_CN.md juicefs-${JFS_LATEST_TAG}-linux-amd64.tar.gz && \
    chmod +x juicefs && mv juicefs ${JUICEFS_PATH} && rm -rf /var/lib/apt/lists/*;

COPY --from=builder /workspace/nuwa /usr/bin/nuwa

CMD ["nuwa", "server"]
