# syntax=docker/dockerfile:experimental

FROM golang:1.18 AS build-env
ENV GO111MODULE on
RUN go install github.com/go-delve/delve/cmd/dlv@v1.8.0

FROM debian:buster

RUN apt-get update && \
    apt-get install procps -y && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build-env /go/bin/dlv /
CMD ["bash", "-c", "/dlv attach $(ps axf | grep $CMD_NAME | grep -v grep | awk '{print $1}') --listen=:8000 --headless=true --api-version=2 --accept-multiclient --continue"]
