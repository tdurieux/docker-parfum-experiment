# builder
FROM golang:1.13-alpine AS builder
WORKDIR /build
COPY . /build
RUN \
  apk update \
  && apk add --no-cache git ca-certificates tzdata \
  && update-ca-certificates
RUN \
  GO111MODULE=on \
  CGO_ENABLED=0 \
  go build \
    -ldflags "-w -s" \
    -o /search \
    ./cmd/search
    
# app