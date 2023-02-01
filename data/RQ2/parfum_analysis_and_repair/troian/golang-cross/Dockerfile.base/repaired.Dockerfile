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
COPY --from=gcr.io/projectsigstore/cosign:v1.4.1@sha256:502d5130431e45f28c51d2c24a05ef5ccd3fd916bcc91db0c8bee3a81e09a0bb /ko-app/cosign /usr/local/bin/cosign
COPY entrypoint.sh /

# Install deps