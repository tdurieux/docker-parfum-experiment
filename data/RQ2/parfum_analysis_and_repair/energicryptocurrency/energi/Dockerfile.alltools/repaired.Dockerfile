# Build energi3 in a stock Go builder container
FROM golang:1.17-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers

ADD . /energi3
RUN cd /energi3 && make all

# Pull all binaries into a second stage deploy alpine container