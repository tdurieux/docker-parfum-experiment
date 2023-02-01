#build stage
FROM golang:alpine AS builder
WORKDIR /go/src/github.com/minotar/imgd
COPY . .
RUN apk add --no-cache git
RUN GO111MODULE=off go get -d -v ./...
RUN GO111MODULE=off go install -v ./...

#final stage