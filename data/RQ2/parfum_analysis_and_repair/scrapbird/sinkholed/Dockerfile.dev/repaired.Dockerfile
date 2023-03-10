FROM golang:1.11.6-alpine as build

ENV GOPATH=""

RUN apk add --update --no-cache git build-base bash

RUN mkdir /opt/sinkholed

WORKDIR /opt/sinkholed

RUN mkdir -p /var/lib/sinkholed/samples
VOLUME /var/lib/sinkholed/samples

VOLUME /etc/sinkholed/certs

ENTRYPOINT ./build.sh && ./entrypoint.sh /opt/sinkholed/bin/sinkholed /tmp/sinkholed.log