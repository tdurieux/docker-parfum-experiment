# ExternalDNS container image

# Stage1: build from source
FROM quay.io/cybozu/golang:1.17-focal AS build

ARG EXTERNALDNS_VERSION=0.11.0

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sSLf https://github.com/kubernetes-sigs/external-dns/archive/v${EXTERNALDNS_VERSION}.tar.gz | \
        tar zxf - -C /work/ \
    && mv external-dns-${EXTERNALDNS_VERSION} /work/external-dns

WORKDIR /work/external-dns/

RUN make build

# Stage2: setup runtime container