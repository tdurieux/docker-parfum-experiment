# Builder
FROM golang:1.15-alpine as builder

WORKDIR /go/src/github.com/grafeas/voucher
COPY . .
RUN apk --no-cache add \
    git \
    make && \
    make voucher_server

# Final build