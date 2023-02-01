# Dockerfile template used by Seihon to create multi-arch images.
# https://github.com/ldez/seihon
FROM golang:1-alpine as builder

RUN apk --update upgrade \
    && apk --no-cache --no-progress add git make ca-certificates tzdata

WORKDIR /go/lego

ENV GO111MODULE on

# Download go modules