# Create base builder image
FROM golang:1.17.9-alpine3.14 AS builder
WORKDIR /go/src/github.com/ava-labs/ortelius
RUN apk add --no-cache alpine-sdk bash git make gcc musl-dev linux-headers git ca-certificates g++ libstdc++


# Build app
COPY . .
RUN if [ -d "./vendor" ];then export MOD=vendor; else export MOD=mod; fi && \
    GOOS=linux GOARCH=amd64 go build -mod=$MOD -o /opt/orteliusd ./cmds/orteliusd/*.go

# Create final image
FROM alpine:3.14 as execution
RUN apk add --no-cache libstdc++
VOLUME /var/log/ortelius
WORKDIR /opt

# Copy in and wire up build artifacts