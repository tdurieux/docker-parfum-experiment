# Build Geth in a stock Go builder container
FROM golang:1.18.1-alpine as builder

ENV GOAMD64=v3

RUN apk add --no-cache make gcc musl-dev linux-headers git

ADD . /go-ethereum
RUN cd /go-ethereum && make geth bootnode

# Pull Geth into a second stage deploy alpine container