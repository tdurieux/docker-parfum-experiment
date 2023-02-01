#
# build oc-daemon binary
#

FROM golang:alpine as builder
ENV GOPATH /go

RUN apk update && apk add --no-cache git ca-certificates tzdata make && update-ca-certificates

RUN adduser -D -g '' opencensus

COPY . $GOPATH/src/github.com/census-instrumentation/opencensus-php/daemon
WORKDIR $GOPATH/src/github.com/census-instrumentation/opencensus-php/daemon

RUN mkdir /newtmp && chown opencensus /newtmp && chmod 777 /newtmp

RUN CGO_ENABLED=0 make build-linux

#
# build image from scratch
#