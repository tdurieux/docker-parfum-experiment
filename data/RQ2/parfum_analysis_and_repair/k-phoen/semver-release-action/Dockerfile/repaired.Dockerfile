# Build
FROM golang:1.13-alpine AS build

RUN apk add --no-cache --update make \
    && rm -f /var/cache/apk/*

WORKDIR /go/src/app
ADD ./ /go/src/app

RUN make build

# Run