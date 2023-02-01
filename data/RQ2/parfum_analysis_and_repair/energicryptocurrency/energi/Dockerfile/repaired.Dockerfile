# Build energi in a stock Go builder container
FROM golang:1.17-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers

ADD . /energi
ENV GOFLAGS='-mod=mod -gcflags -dwarf=0 -ldflags "-s -w"'
RUN cd /energi && make geth

# Pull energi into a second stage deploy alpine container