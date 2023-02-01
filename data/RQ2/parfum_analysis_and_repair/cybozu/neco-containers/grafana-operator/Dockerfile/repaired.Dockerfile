# Grafana Operator container

# Stage1: build from source
FROM quay.io/cybozu/golang:1.17-focal AS build
ARG VERSION=4.2.0

WORKDIR /work/grafana-operator
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sSLf https://github.com/grafana-operator/grafana-operator/archive/v${VERSION}.tar.gz | \
    tar zxf - --strip-components 1 -C /work/grafana-operator

RUN CGO_ENABLED=0 GO111MODULE=on go build -o /usr/local/bin/grafana-operator main.go

# https://github.com/grafana-operator/grafana-operator/blob/master/.gitmodules
RUN git clone --depth 1 https://github.com/grafana/grafonnet-lib

# Stage2: setup runtime container
# refer to : https://github.com/grafana-operator/grafana-operator/blob/master/build/Dockerfile