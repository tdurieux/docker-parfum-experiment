# Build webchaind in a stock Go builder container
FROM golang:1.12-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git bash cargo

ENV GOPATH=/go
RUN mkdir -p /go/src/github.com/webchain-network/webchaind

ADD . /go/src/github.com/webchain-network/webchaind

WORKDIR /go/src/github.com/webchain-network/webchaind

RUN make cmd/webchaind

# Pull webchaind into a second stage deploy alpine container