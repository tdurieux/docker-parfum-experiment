# Builder
FROM golang:1.16-alpine as builder

LABEL maintainer "catherinejones"
WORKDIR /go/src/github.com/grafeas/voucher
RUN apk --no-cache add \
    git \
    make
COPY Makefile .
COPY v2/go.mod v2/
COPY v2/go.sum v2/
RUN make ensure-deps
COPY . .
RUN make voucher_server

# Final build