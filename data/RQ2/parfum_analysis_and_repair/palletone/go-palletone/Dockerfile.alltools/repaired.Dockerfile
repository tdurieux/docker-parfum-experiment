# Build Gptn in a stock Go builder container
FROM golang:1.10-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers

ADD . /go-palletone
RUN cd /go-palletone && make all

# Pull all binaries into a second stage deploy alpine container