# Use this file when golang.org/go.googlesource.com is blocked.
#
# Build with:
#
# docker build . -f Dockerfile.github -t ochinchina/supervisord:latest
#
FROM golang:alpine as builder

RUN apk add --no-cache --update git

RUN mkdir -p $GOPATH/src/golang.org/x && \
    cd $GOPATH/src/golang.org/x && \
    git clone https://github.com/golang/crypto && \
    git clone https://github.com/golang/sys

# Exit 0 to ignore meta tag complaints