# Build the manager binary
FROM registry.cn-hangzhou.aliyuncs.com/knative-sample/golang:1.12.9 as builder

# Copy in the go src
WORKDIR /go/src/github.com/apache/rocketmq-externals/rocketmq-knative/source/
COPY cmd/   cmd/
COPY pkg/    pkg/
COPY vendor/ vendor/

# Build