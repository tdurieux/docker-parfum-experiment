# Build the manager binary
FROM golang:1.16-alpine as builder

## GOLANG env
ARG GOPROXY="https://proxy.golang.org|direct"
ARG GO111MODULE="on"
ARG CGO_ENABLED=0
ARG GOOS=linux
ARG GOARCH=amd64

# Copy go.mod and download dependencies
WORKDIR /webhook-test-proxy

# Build
COPY . .
RUN go build -ldflags="-s -w" -a -o webhook-test-proxy cmd/webhook-test-proxy.go
# In case the target is build for testing:
# $ docker build  --target=builder -t test .
ENTRYPOINT ["webhook-test-proxy"]

# Copy the webhook-test-proxy binary into a thin image