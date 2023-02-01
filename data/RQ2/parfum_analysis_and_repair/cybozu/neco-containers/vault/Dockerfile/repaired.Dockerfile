# vault container

# Stage1: build from source
FROM quay.io/cybozu/golang:1.17-focal AS build

ARG VAULT_VERSION=1.11.0

RUN git clone --depth=1 -b v${VAULT_VERSION} https://github.com/hashicorp/vault.git

WORKDIR /work/vault

RUN make bootstrap && \
    make fmt && \
    make

# Stage2: setup runtime container