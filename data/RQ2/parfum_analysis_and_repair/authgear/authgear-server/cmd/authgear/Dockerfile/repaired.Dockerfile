# Stage 1: Build the Go binary
FROM golang:1.18.2-bullseye as stage1

# Install build time C dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    pkg-config \
    libicu-dev \
    libvips-dev \
    libmagic-dev \
    && rm -rf /var/lib/apt/lists/*

ARG GIT_HASH
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN make build BIN_NAME=authgear TARGET=authgear GIT_HASH=$GIT_HASH

# We used to build static binary.
# But we have a transitive dependency on icu4c so this is no longer the case.
# RUN readelf -d ./authgear | grep 'There is no dynamic section in this file'

# Stage 2: Build the static files
FROM node:16.15.1-bullseye as stage2
ARG GIT_HASH
WORKDIR /usr/src/app
COPY ./scripts/npm/package.json ./scripts/npm/package-lock.json ./scripts/npm/
RUN cd ./scripts/npm && npm ci
COPY ./authui/package.json ./authui/package-lock.json ./authui/
RUN cd ./authui && npm ci
COPY . .
RUN make authui GIT_HASH=$GIT_HASH

# Stage 3: Prepare the actual fs we use to run the program
FROM debian:bullseye-20220125-slim
ARG GIT_HASH
WORKDIR /app
# /etc/mime.types (mime-support)
# /usr/share/ca-certificates/*/* (ca-certificates)
# /usr/share/zoneinfo/ (tzdata)