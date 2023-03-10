# Build Gwan in a stock Go builder container
FROM golang:1.12-alpine as builder

RUN apk add --no-cache make gcc git musl-dev linux-headers

ADD . /go-wanchain
RUN cd /go-wanchain && make gwan

# Pull Geth into a second stage deploy alpine container