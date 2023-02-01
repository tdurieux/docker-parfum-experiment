# Builder image
FROM golang:1.13.5-alpine3.11 as builder

RUN apk add --no-cache \
    make \
    git

COPY . /go/src/github.com/distributedio/titan

WORKDIR /go/src/github.com/distributedio/titan

RUN env GOOS=linux CGO_ENABLED=0 make

# Executable image