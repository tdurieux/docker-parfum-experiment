ARG ALPINE_VERSION="3.10"
ARG S6_OVERLAY_VERSION="1.22.1.0"

FROM golang:1.12-alpine${ALPINE_VERSION} AS builder

ARG GPHOTOS_UPLOADER_CLI_VERSION="1.0.6"

ENV GOOS=linux \
    GOARCH=amd64

COPY patches /tmp/patches

RUN \
    apk update && \
    apk add --no-cache --virtual build-dependencies \
        g++ \
        git \
        make && \
    git clone https://github.com/gphotosuploader/gphotos-uploader-cli.git \
        --branch v${GPHOTOS_UPLOADER_CLI_VERSION} \
        --single-branch && \
    cd /go/gphotos-uploader-cli && \
    git apply /tmp/patches/gphotos-uploader-cli/*.patch \
        --ignore-whitespace \
        --verbose && \
    make build VERSION="${GPHOTOS_UPLOADER_CLI_VERSION}-docker" && \
    apk del build-dependencies

FROM amd64/alpine:${ALPINE_VERSION}

LABEL maintainer="master@ricardoamaral.net"

ARG BUILD_DATE
ARG S6_OVERLAY_VERSION
ARG VCS_REF

LABEL \
    org.label-schema.build-date="${BUILD_DATE}" \
    org.label-schema.description="Mass upload media folders to your Google Photos account with this Docker image." \
    org.label-schema.name="rfgamaral/gphotos-uploader" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.vcs-ref="${VCS_REF}" \
    org.label-schema.vcs-url="https://github.com/rfgamaral/docker-gphotos-uploader.git"

ENV GPU_SCHEDULE="0 */8 * * *"

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz /tmp/

RUN \
    apk update && \
    apk add --no-cache \
        ca-certificates \
        openssl && \
    tar xzf /tmp/s6-overlay-amd64.tar.gz --directory / && \
    rm -rf /tmp/*

COPY --from=builder /go/gphotos-uploader-cli /usr/local/bin/

COPY rootfs/ /

VOLUME ["/config", "/photos"]

ENTRYPOINT ["/init"]
