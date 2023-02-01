# The base cloud-game image
ARG BUILD_PATH=/go/src/github.com/giongto35/cloud-game

# build image
FROM debian:bullseye-slim AS build
ARG BUILD_PATH
WORKDIR ${BUILD_PATH}

# system libs layer
RUN apt-get -qq update && apt-get -qq install --no-install-recommends -y \
    gcc \
    ca-certificates \
    libopus-dev \
    libsdl2-dev \
    libvpx-dev \
    libx264-dev \
    make \
    pkg-config \
    wget \
 && rm -rf /var/lib/apt/lists/*

# go setup layer
ARG GO=go1.18.linux-amd64.tar.gz
RUN wget -q https://golang.org/dl/$GO \
    && rm -rf /usr/local/go \
    && tar -C /usr/local -xzf $GO \
    && rm $GO
ENV PATH="${PATH}:/usr/local/go/bin"

# go deps layer
COPY go.mod go.sum ./
RUN go mod download

# app build layer
COPY pkg ./pkg
COPY cmd ./cmd
COPY Makefile .
COPY scripts/version.sh scripts/version.sh
ARG VERSION
RUN GIT_VERSION=${VERSION} make build

# base image