FROM golang:alpine

ENV CGO_ENABLED 1
ENV GOOS linux
ENV GOARCH amd64

# add build deps
RUN apk add --no-cache -U git build-base
