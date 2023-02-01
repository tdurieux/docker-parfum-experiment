#
# STAGE 1: build executable binary
#
FROM golang:1.17-alpine as builder
WORKDIR /app

#
# build server
COPY . .
RUN go get -v -t -d .; \
    CGO_ENABLED=0 go build -o go-transcode

#
# STAGE 2: build a small image
#
FROM alpine:edge
WORKDIR /app

#
# install dependencies
RUN apk add --no-cache bash ffmpeg

#
# install vdpau dependencies