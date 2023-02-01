# BUILD STAGE
FROM golang:1.17-alpine AS build

ARG APP_VERSION
ARG CGO=1
ENV CGO_ENABLED=${CGO}
ENV GOOS=linux
ENV GO111MODULE=on

# gcc/g++ are required by sqlite driver
RUN apk update && apk add --no-cache gcc g++

WORKDIR /build
COPY . .
RUN go build -v -a -tags 'netgo' -ldflags '-w -X 'main.Version=${APP_VERSION}' -extldflags "-static"' -o chaos cmd/chaos/*

# FINAL STAGE