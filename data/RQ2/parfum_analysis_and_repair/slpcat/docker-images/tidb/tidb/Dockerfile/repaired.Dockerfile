#upstream https://github.com/pingcap/tidb/raw/master/Dockerfile
# Builder image
FROM golang:1.10.1-alpine as builder

RUN apk add --no-cache \
    make \
    git

COPY . /go/src/github.com/pingcap/tidb

WORKDIR /go/src/github.com/pingcap/tidb/

RUN make

# Executable image