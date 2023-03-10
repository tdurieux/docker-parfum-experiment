# Build Geth in a stock Go builder container
FROM golang:1.18.1-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git

ADD . /bor
RUN cd /bor && make bor-all

# Pull all binaries into a second stage deploy alpine container