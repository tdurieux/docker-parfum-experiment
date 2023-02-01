# Build the manager binary
FROM golang:1.16 as builder

WORKDIR /workspace

# Dependencies are cached unless we change go.mod or go.sum
COPY go.mod go.mod
COPY go.sum go.sum
# RUN go mod download

# Copy the go source
COPY main.go main.go
COPY api/ api/
COPY controllers/ controllers/
COPY internal/ internal/
COPY sieve-dependency/ sieve-dependency/

# Build
RUN go mod download k8s.io/apimachinery
RUN go mod download k8s.io/klog
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a -tags timetzdata -o manager main.go

# ---------------------------------------
FROM alpine:latest as etc-builder

RUN echo "rabbitmq-cluster-operator:x:1000:" > /etc/group && \
    echo "rabbitmq-cluster-operator:x:1000:1000::/home/rabbitmq-cluster-operator:/usr/sbin/nologin" > /etc/passwd


RUN apk add -U --no-cache ca-certificates

# ---------------------------------------