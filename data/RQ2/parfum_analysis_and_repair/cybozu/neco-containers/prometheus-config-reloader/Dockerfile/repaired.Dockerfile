# prometheus-config-reloader container

# Stage1: build from source
FROM quay.io/cybozu/golang:1.17-focal AS build

ARG PROMETHEUS_OPERATOR_VERSION=0.55.1

RUN curl -fsSL -o prometheus-operator.tar.gz "https://github.com/prometheus-operator/prometheus-operator/archive/v${PROMETHEUS_OPERATOR_VERSION}.tar.gz" \
    && tar -x -z --strip-components 1 -f prometheus-operator.tar.gz \
    && rm -f prometheus-operator.tar.gz \
    && CGO_ENABLED=0 go install -ldflags="-w -s" ./cmd/prometheus-config-reloader

# Stage2: setup runtime container