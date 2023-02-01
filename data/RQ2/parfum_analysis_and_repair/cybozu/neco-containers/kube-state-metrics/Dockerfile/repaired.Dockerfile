# kube-state-metrics container

# Stage1: build from source
FROM quay.io/cybozu/golang:1.17-focal AS build

ARG KUBE_STATE_METRICS_VERSION=2.2.4
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -fsSL https://github.com/kubernetes/kube-state-metrics/archive/v${KUBE_STATE_METRICS_VERSION}.tar.gz | \
    tar --strip-components=1 -xzf -

RUN make build-local

# Stage2: setup runtime container