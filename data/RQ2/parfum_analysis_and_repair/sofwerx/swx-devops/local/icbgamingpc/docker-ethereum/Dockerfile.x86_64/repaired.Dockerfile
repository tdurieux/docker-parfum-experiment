# Build Geth in a stock Go builder container
FROM golang:1.9-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git bash

ENV GETH_VERSION=v1.8.16
RUN git clone -b $GETH_VERSION https://github.com/ethereum/go-ethereum /go-ethereum
RUN cd /go-ethereum && make all

# Pull all binaries into a second stage deploy alpine container