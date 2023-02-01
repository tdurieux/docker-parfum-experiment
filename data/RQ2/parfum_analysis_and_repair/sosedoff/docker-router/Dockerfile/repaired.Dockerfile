# ------------------------------------------------------------------------------
# Build Phase
# ------------------------------------------------------------------------------

FROM golang:1.13 AS build

ADD . /go/src/github.com/sosedoff/docker-router
WORKDIR /go/src/github.com/sosedoff/docker-router

RUN \
  GOOS=linux \
  GOARCH=amd64 \
  CGO_ENABLED=0 \
  go build -o /docker-router

# ------------------------------------------------------------------------------
# Package Phase
# ------------------------------------------------------------------------------