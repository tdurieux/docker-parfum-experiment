# To build run:
# $ poetry build
# $ docker build -t ghcr.io/ep1cman/unifi-protect-backup .

FROM ghcr.io/linuxserver/baseimage-alpine:3.15

LABEL maintainer="ep1cman"

WORKDIR /app

COPY dist/unifi-protect-backup-0.8.0.tar.gz sdist.tar.gz

RUN \
    echo "**** install build packages ****" && \
    apk add --no-cache --virtual=build-dependencies \
    gcc \
    musl-dev \
    jpeg-dev \
    zlib-dev \
    python3-dev && \
    echo "**** install packages ****" && \
    apk add --no-cache \
    rclone \
    ffmpeg \
    py3-pip \
    python3 && \
    echo "**** install unifi-protect-backup ****" && \
    pip install --no-cache-dir sdist.tar.gz && \
    echo "**** cleanup ****" && \
    apk del --purge \
    build-dependencies && \
    rm -rf \
    /tmp/* \
    /app/sdist.tar.gz

# Settings