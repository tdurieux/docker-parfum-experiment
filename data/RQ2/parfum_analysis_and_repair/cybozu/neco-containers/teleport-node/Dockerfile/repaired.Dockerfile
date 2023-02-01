# Stage1: build from source
FROM quay.io/cybozu/golang:1.17-focal AS build

ARG TELEPORT_VERSION=8.3.6
RUN git clone --depth 1 --branch v${TELEPORT_VERSION} https://github.com/gravitational/teleport && \
    cd teleport && \
    make build/teleport OS=linux

# Stage2: setup runtime container