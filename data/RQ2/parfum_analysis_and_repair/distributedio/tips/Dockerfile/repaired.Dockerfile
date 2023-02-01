#Builder image
FROM golang:1.10.1-alpine as builder

RUN apk add --no-cache \
    make \
    git

COPY . /go/src/github.com/tipsio/tips

WORKDIR /go/src/github.com/tipsio/tips/tipsd

RUN env GOOS=linux CGO_ENABLED=0 go build

# Executable image
#FROM debian:stretch-slim