# Build stage
FROM golang:1.18.3-alpine AS builder
COPY ./.git build/.git
COPY ./pkg  build/pkg
COPY ./migration-tool build/migration-tool
COPY ./go.mod build/go.mod
COPY ./go.sum build/go.sum
RUN apk update && apk add --no-cache git \
    && cd build \
    && go mod download \
    && GIT_COMMIT=$(git rev-list -1 HEAD) \
    && cd migration-tool/ \
    && CGO_ENABLED=0 go build -a \
    -o /go/prom-migrator ./cmd/prom-migrator

# Final image