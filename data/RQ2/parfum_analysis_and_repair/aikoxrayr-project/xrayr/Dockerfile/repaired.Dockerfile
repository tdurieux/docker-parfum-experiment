# Build go
FROM golang:1.18.1-alpine AS builder
WORKDIR /app
COPY . .
ENV CGO_ENABLED=0
RUN go mod download && \
    go env -w GOFLAGS=-buildvcs=false && \
    go build -v -o XrayR -trimpath -ldflags "-s -w -buildid=" ./main

# Release