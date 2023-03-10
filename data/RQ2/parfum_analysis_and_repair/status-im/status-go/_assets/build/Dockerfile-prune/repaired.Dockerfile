# Build status-go in a Go builder container
FROM golang:1.13-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers

RUN mkdir -p /go/src/github.com/status-im/status-go
ADD . /go/src/github.com/status-im/status-go
RUN cd /go/src/github.com/status-im/status-go && make statusd-prune

# Copy the binary to the second image