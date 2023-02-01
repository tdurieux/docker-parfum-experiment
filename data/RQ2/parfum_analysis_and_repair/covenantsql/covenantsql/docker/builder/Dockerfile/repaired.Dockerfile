FROM golang:alpine3.10
MAINTAINER auxten

RUN apk add --no-cache build-base
RUN apk add --no-cache make
RUN apk add --no-cache git
RUN apk add --no-cache icu-dev
RUN apk add --no-cache icu-static

WORKDIR $GOPATH
