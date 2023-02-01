# ---- Stage 0 ----
# Builds media repo binaries
FROM golang:1.16-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git musl-dev dos2unix build-base

WORKDIR /opt
COPY . /opt
RUN dos2unix ./build.sh
RUN ./build.sh

# ---- Stage 1 ----
# Final runtime stage.