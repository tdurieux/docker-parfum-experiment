# Build Linkeye in a stock Go builder container
FROM golang:1.10.4-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git

ADD . /linkeye
RUN cd /linkeye && make all

# Pull all binaries into a second stage deploy alpine container