# Build Stage
ARG GO_VERSION
FROM golang:$GO_VERSION-alpine AS build
RUN apk add --no-cache bash build-base git tree curl protobuf openssh
WORKDIR /src

ENV GOBIN=/bin
ENV ROOT_DIR=/src

# generate & build