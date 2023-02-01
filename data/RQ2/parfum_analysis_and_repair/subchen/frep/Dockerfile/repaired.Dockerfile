###############################
FROM golang:1.18-alpine AS build

RUN mkdir -p /go/src/github.com/subchen/frep
COPY . /go/src/github.com/subchen/frep
WORKDIR /go/src/github.com/subchen/frep

RUN apk add --no-cache make git
RUN make clean build-linux

###############################