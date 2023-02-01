# kubernetes container

# Stage1: build from source
FROM quay.io/cybozu/golang:1.17-focal AS build

ARG K8S_VERSION=1.22.11

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update \
    && apt-get -y install --no-install-recommends \
    rsync \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /go/src/k8s.io/ && \
    curl -sSLf https://github.com/kubernetes/kubernetes/archive/v${K8S_VERSION}.tar.gz | \
      tar zxf - -C /go/src/k8s.io/ && \
    mv /go/src/k8s.io/kubernetes-${K8S_VERSION} /go/src/k8s.io/kubernetes

COPY 89155.patch 97081.patch /tmp/

WORKDIR /go/src/k8s.io/kubernetes
RUN patch -p1 --no-backup-if-mismatch < /tmp/89155.patch && \
    patch -p1 --no-backup-if-mismatch < /tmp/97081.patch && \
    make all WHAT="cmd/kube-apiserver cmd/kube-controller-manager cmd/kube-proxy cmd/kube-scheduler cmd/kubelet" GOLDFLAGS="-w -s"

# Stage2: setup runtime container