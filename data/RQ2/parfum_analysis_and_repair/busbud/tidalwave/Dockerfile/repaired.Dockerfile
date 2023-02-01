# Builder
FROM golang:1.12-alpine3.9 as builder

RUN apk add --no-cache git build-base bash

WORKDIR /build
COPY ./go.mod ./go.sum ./
RUN go mod download

COPY . .
RUN make

# App