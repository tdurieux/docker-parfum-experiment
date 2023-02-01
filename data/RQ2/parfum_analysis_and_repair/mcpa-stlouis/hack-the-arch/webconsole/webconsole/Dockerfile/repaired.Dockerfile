# Webconsole Dockerfile v1.0
# Build stage
FROM golang:1.12-alpine as builder
MAINTAINER Paul Jordan <paullj1@gmail.com>

RUN apk update && apk add --no-cache upx git

WORKDIR /go/src/cydefe.com/webconsole
COPY webconsole.go .
RUN go get -v -d .

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" . \
  && upx --brute webconsole

# Package stage