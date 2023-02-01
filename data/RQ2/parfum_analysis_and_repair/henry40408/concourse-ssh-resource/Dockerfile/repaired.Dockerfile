# build stage

FROM golang:alpine as builder

COPY . /go/src/github.com/henry40408/concourse-ssh-resource

RUN apk --no-cache add make && \
  cd /go/src/github.com/henry40408/concourse-ssh-resource && \
  make build-linux

WORKDIR /opt/resource

# release stage