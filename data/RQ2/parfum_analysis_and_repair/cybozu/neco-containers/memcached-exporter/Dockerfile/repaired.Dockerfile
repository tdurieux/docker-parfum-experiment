# memcached_exporter container

# Stage1: build from sourceFROM quay.io/cybozu/ubuntu-dev:20.04 AS build
FROM quay.io/cybozu/golang:1.17-focal AS build

ARG MEMCACHED_EXPORTER_VERSION=0.9.0

WORKDIR /work
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN git clone --depth=1 -b v${MEMCACHED_EXPORTER_VERSION} https://github.com/prometheus/memcached_exporter /work/memcached_exporter

WORKDIR /work/memcached_exporter
RUN make build

# Stage2: setup runtime container