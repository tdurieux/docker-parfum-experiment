# Builder
FROM golang:1.18.2-alpine3.14 AS build

WORKDIR /promcheck

COPY . ./
RUN apk --no-cache add make git gcc libc-dev curl ca-certificates && make release

# Image