# Build Ghpb in a stock Go builder container
FROM golang:alpine as builder
RUN apk add --no-cache make git gcc musl-dev linux-headers

ADD . /go-hpb
ENV GO111MODULE off
RUN cd /go-hpb && make ghpb
# Pull Ghpb into a second stage deploy alpine container