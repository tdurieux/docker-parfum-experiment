FROM golang:1.17-alpine AS builder
RUN apk add -U --no-cache \
    build-base \
    ca-certificates \
    git \
    sqlite \
    taglib-dev \
    alsa-lib-dev \
    zlib-dev
WORKDIR /src