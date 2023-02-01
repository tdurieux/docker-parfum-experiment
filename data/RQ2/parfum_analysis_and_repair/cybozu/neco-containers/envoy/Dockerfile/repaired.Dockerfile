# Envoy container

# Stage1: build from source
FROM quay.io/cybozu/golang:1.17-focal AS build

COPY . /work

WORKDIR /work

RUN go install -ldflags="-w -s" ./pkg/livenessprobe

# Stage2: setup runtime container