# Build Geth in a stock Go build container
FROM golang:1.18-alpine as builder

# Unused, this is here to avoid build time complaints
ARG DOCKER_TAG

ARG BUILD_TARGET

RUN apk update && apk add --no-cache make gcc musl-dev linux-headers git bash

WORKDIR /src
RUN bash -c "git clone https://github.com/ethereum/go-ethereum.git && cd go-ethereum && git config advice.detachedHead false && git fetch --all --tags && git checkout ${BUILD_TARGET} && make geth"

# Pull all binaries into a second stage deploy container
FROM alpine:latest

ARG USER=geth
ARG UID=10001

RUN apk add --no-cache ca-certificates tzdata

# See https://stackoverflow.com/a/55757473/12429735RUN
RUN adduser \
    --disabled-password \
    --gecos "" \
    --shell "/sbin/nologin" \
    --uid "${UID}" \
    "${USER}"

RUN mkdir -p /var/lib/goethereum && chown ${USER}:${USER} /var/lib/goethereum

# Copy executable