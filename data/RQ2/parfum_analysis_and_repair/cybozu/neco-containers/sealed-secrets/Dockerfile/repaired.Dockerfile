# Build stage
FROM quay.io/cybozu/golang:1.17-focal AS build

ARG SEALED_SECRETS_VERSION=0.17.4

RUN curl -sLf -o sealed-secrets.tar.gz https://github.com/bitnami-labs/sealed-secrets/archive/v${SEALED_SECRETS_VERSION}.tar.gz \
    && tar --strip-components=1 -xzf sealed-secrets.tar.gz \
    && rm sealed-secrets.tar.gz \
    && make TAG=${SEALED_SECRETS_VERSION} controller-static

# Runtime stage