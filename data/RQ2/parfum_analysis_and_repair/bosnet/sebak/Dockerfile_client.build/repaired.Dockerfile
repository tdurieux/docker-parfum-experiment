## Builder part is quite heavy as it depends on the Go toolchain
FROM golang:1.11-alpine AS builder
LABEL maintainer="BOSCoin Developers <devteam@boscoin.io>"


RUN apk add --no-cache git openssh gcc musl-dev linux-headers
RUN go get github.com/ahmetb/govvv

#golang:alpine set $GOPATH to `/go`
COPY ./ /sebak-build
WORKDIR /sebak-build

# You probably don't need to change this