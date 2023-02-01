# Building app with golang container
FROM golang:1.16-alpine as builder

RUN apk --no-cache --no-progress add git make ca-certificates tzdata\
    && rm -rf /var/cache/apk/*

WORKDIR /go/traefik-migration-tool

# Download go modules
COPY go.mod .
COPY go.sum .
RUN GO111MODULE=on GOPROXY=https://proxy.golang.org go mod download

COPY . .

RUN make build

## IMAGE