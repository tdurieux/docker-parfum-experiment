# Dockerfile for creating a Docker image that contains the Linux x64 binary
#
# It makes use of multi-stage builds and requires Docker 17.05 or later:
# https://docs.docker.com/engine/userguide/eng-image/multistage-build/

# Builder image
# Don't bother to clean up the image - it's only used for building
FROM golang:1.10-alpine as builder

RUN apk add --no-cache git

RUN go env
RUN go get -v "github.com/philippgille/ln-paywall/..."
RUN go get -v "github.com/skip2/go-qrcode"

WORKDIR /go/src/api
COPY main.go .
RUN go build -v

# Runtime image