# Build Taiyue in a stock Go builder container
FROM golang:1.10-alpine as construction

RUN apk add --no-cache make gcc git musl-dev linux-headers

ADD . /taiyuechain
RUN cd /taiyuechain && make taiyue

# Pull Taiyue into a second stage deploy alpine container