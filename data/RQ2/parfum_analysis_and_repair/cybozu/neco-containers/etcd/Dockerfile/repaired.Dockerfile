# etcd container

# Stage1: build from source
FROM quay.io/cybozu/golang:1.17-focal AS build

ARG ETCD_VERSION=3.5.4

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sSLf https://github.com/etcd-io/etcd/archive/v${ETCD_VERSION}.tar.gz | \
        tar zxf - \
    && mv etcd-${ETCD_VERSION} etcd

WORKDIR /work/etcd
RUN ./build.sh

# Stage2: setup runtime container