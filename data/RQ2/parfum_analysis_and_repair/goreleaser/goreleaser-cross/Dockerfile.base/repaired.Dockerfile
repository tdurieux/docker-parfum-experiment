# golang parameters
ARG GO_VERSION

FROM golang:${GO_VERSION}-bullseye
LABEL maintainer="Artur Troian <troian dot ap at gmail dot com>"
LABEL "org.opencontainers.image.source"="https://github.com/goreleaser/goreleaser-cross-base"

ARG DEBIAN_FRONTEND=noninteractive
ARG GORELEASER_VERSION
ARG APT_MIRROR
ARG TINI_VERSION
ARG COSIGN_VERSION
ARG COSIGN_SHA256
ARG GORELEASER_DOWNLOAD_URL=https://github.com/goreleaser/goreleaser/releases/download/v${GORELEASER_VERSION}

# install cosign
COPY --from=gcr.io/projectsigstore/cosign:v1.9.0@sha256:ef2d14e16dbb7786d8713e4898a8512e69ace4105f5b371a9c115ffcc3e85d84 /ko-app/cosign /usr/local/bin/cosign
COPY entrypoint.sh /

# Install deps