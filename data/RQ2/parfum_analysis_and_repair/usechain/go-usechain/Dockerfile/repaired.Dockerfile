# Build Used in a stock Go builder container
FROM golang:1.12-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git

ADD . /go-usechain
RUN cd /go-usechain && make used
RUN strip /go-usechain/build/bin/used

# Pull Geth into a second stage deploy alpine container