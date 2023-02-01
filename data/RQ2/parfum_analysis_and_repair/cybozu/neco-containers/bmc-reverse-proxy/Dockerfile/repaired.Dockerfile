# bmc-reverse-proxy container

# Stage1: build from source
FROM quay.io/cybozu/golang:1.17-focal AS build

COPY . /work

WORKDIR /work

RUN CGO_ENABLED=0 go install -ldflags="-w -s" ./pkg/bmc-reverse-proxy

# Stage2: setup runtime container