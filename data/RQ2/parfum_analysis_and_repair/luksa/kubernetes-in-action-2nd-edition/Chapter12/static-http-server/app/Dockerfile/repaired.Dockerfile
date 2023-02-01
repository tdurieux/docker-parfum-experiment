# syntax=docker/dockerfile:1

# 1. Create the base image
# The base image contains the source code and the go dependencies
FROM --platform=${BUILDPLATFORM} golang:1.16 AS base
WORKDIR /src
ENV CGO_ENABLED=0
COPY go.* .
RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download

# 2. Create the build image
FROM base as build
ARG TARGETOS
ARG TARGETARCH
RUN --mount=target=. \
    --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /out/static-http-server .

# 3. Create the