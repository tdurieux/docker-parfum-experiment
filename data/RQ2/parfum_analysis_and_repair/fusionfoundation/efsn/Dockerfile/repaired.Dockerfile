# Build Efsn in a stock Go builder container
FROM golang:1.17.8-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers

ADD . /efsn
RUN cd /efsn && make efsn

# Pull Geth into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
# RUN apk add --no-cache jq