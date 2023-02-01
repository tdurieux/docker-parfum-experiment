# Build Bytom in a stock Go builder container
FROM golang:1.9-alpine as builder

RUN apk add --no-cache make git

ADD . /go/src/github.com/bytom/bytom
RUN cd /go/src/github.com/bytom/bytom && make bytomd && make bytomcli

# Pull Bytom into a second stage deploy alpine container