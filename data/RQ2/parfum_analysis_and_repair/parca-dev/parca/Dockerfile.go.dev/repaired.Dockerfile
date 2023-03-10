# Designed to only used by Tilt to iterate faster on the API.
FROM docker.io/golang:1.18.4-alpine@sha256:46f1fa18ca1ec228f7ea4978ad717f0a8c5e51436e7b8efaf64011f7729886df AS builder

# renovate: datasource=go depName=github.com/go-delve/delve
ARG DLV_VERSION=v1.9.0

# renovate: datasource=go depName=github.com/grpc-ecosystem/grpc-health-probe
ARG GRPC_HEALTH_PROBE_VERSION=v0.4.11

WORKDIR /app

# hadolint ignore=DL3018
RUN apk update && apk add --no-cache build-base
RUN go install "github.com/go-delve/delve/cmd/dlv@${DLV_VERSION}"
# hadolint ignore=DL3059
RUN go install "github.com/grpc-ecosystem/grpc-health-probe@${GRPC_HEALTH_PROBE_VERSION}"

COPY go.mod go.sum /app/
RUN go mod download -modcacherw

# Create a dummy ui package to convience go compiler.
RUN mkdir -p /app/ui/packages/app/web/build && \
    touch /app/ui/packages/app/web/build/index.html && \
    printf 'package ui\n \
    import "embed"\n\
    //go:embed packages/app/web/build\n\
    var FS embed.FS\n'\
    > ./ui/ui.go

COPY ./cmd /app/cmd
COPY ./pkg /app/pkg
COPY ./proto /app/proto
COPY ./gen /app/gen

# goreleaser build --single-target