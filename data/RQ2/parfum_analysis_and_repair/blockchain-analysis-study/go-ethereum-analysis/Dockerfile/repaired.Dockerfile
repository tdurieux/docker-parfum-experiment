# Build Geth in a stock Go builder container
FROM golang:1.10-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers

ADD . /github.com/go-ethereum-analysis
RUN cd /github.com/go-ethereum-analysis && make geth

# Pull Geth into a second stage deploy alpine container