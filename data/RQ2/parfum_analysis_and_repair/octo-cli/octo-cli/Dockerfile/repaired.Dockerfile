# Build
FROM golang:1.11-alpine AS octo-cli-build-env

RUN apk add --no-cache git musl-dev gcc bash

WORKDIR /go/src/github.com/octo-cli/octo-cli
COPY . .

RUN script/build

# Package