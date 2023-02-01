## build
FROM golang:1.15-buster AS build-env

ADD . /go/src/atomci

WORKDIR /go/src/atomci

RUN make build

## run