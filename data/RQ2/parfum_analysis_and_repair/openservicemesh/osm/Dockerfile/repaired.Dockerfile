#build stage
FROM golang:1.17-alpine AS builder

RUN apk update
RUN apk add --no-cache make
RUN apk add --no-cache git
RUN apk add --no-cache build-base
RUN apk add --no-cache bash
ENV GOPATH=/usr/local/go/tools
RUN go get -u golang.org/x/tools/...
RUN go get -u golang.org/x/tools/gopls/...
RUN go get -u github.com/go-delve/delve/cmd/dlv
