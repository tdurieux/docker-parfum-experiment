FROM golang:1.12.7-alpine

RUN apk add --no-cache gcc musl-dev bash

WORKDIR /go/src/github.com/orbs-network/orbs-network-go/

ADD . /go/src/github.com/orbs-network/orbs-network-go/