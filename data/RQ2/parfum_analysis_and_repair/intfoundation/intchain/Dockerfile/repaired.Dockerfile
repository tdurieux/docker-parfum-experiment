# Build intchain in a stock Go builder container
FROM golang:1.14-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers

ADD . /intchain
RUN cd /intchain && make intchain

# Pull Intchain into a second stage deploy alpine container