FROM golang:1.11.2-alpine

RUN apk add --no-cache make git bash
RUN mkdir -p /go/src/github.com/kelseyhightower/confd && \
  ln -s /go/src/github.com/kelseyhightower/confd /app

WORKDIR /app
