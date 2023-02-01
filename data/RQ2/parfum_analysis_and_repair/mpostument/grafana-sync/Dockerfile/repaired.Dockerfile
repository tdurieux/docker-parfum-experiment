# Build App
FROM golang:1.17.11-alpine AS builder

WORKDIR ${GOPATH}/src/github.com/mpostument/grafana-sync
COPY . ${GOPATH}/src/github.com/mpostument/grafana-sync

RUN go build -o /go/bin/grafana-sync .


# Create small image with binary