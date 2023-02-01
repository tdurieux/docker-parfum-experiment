# Build Geth in a stock Go builder container
FROM golang:1.15-alpine as construction

RUN apk add --no-cache make gcc musl-dev linux-headers

ADD . /abey
RUN cd /abey && make gabey

# Pull Geth into a second stage deploy alpine container