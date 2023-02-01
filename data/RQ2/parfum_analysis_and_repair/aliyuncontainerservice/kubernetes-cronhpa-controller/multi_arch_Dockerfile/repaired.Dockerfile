# Build the manager binary
FROM --platform=$BUILDPLATFORM golang:1.14.2 as builder
ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG BUILDARCH
ARG TARGETARCH

ENV GOPROXY=https://goproxy.cn,direct

# Copy in the go src
WORKDIR /go/src/github.com/AliyunContainerService/kubernetes-cronhpa-controller
COPY pkg/    pkg/
COPY cmd/    cmd/
COPY vendor/ vendor/

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=$TARGETARCH GO111MODULE=off go build -a -o kubernetes-cronhpa-controller github.com/AliyunContainerService/kubernetes-cronhpa-controller/cmd/kubernetes-cronhpa-controller

# Copy the controller-manager into a thin image