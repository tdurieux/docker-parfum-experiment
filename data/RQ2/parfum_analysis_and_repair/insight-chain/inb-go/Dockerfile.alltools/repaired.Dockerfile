# Build Geth in a stock Go builder container
FROM golang:1.11-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers

ADD . /inb-go
RUN cd /inb-go && make all

# Pull all binaries into a second stage deploy alpine container