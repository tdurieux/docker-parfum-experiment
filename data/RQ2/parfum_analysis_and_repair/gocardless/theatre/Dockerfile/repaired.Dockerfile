# Build Go binary without cgo dependencies
FROM golang:1.17.3 as builder
WORKDIR /go/src/github.com/gocardless/theatre

COPY . /go/src/github.com/gocardless/theatre
RUN make VERSION=$(cat VERSION) build

# Use ubuntu as our base package to enable generic system tools
FROM ubuntu:focal-20211006

# Without these certificates we'll fail to validate TLS connections to Google's
# services.