# syntax = docker/dockerfile:experimental

FROM golang:alpine AS builder

RUN apk add --no-cache git gcc libc-dev openssh

RUN mkdir -p /tmp/wp-prime
COPY go.sum /tmp/wp-prime
COPY go.mod /tmp/wp-prime

WORKDIR /tmp/wp-prime

RUN mkdir -p -m 0600 ~/.ssh \
    && ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
RUN git config --global url.ssh://git@github.com/.insteadOf https://github.com/
RUN --mount=type=ssh go mod download

COPY . /tmp/wp-src

WORKDIR /tmp/wp-src

RUN apk add --no-cache make
RUN go get github.com/kevinburke/go-bindata/...
RUN --mount=type=cache,target=/root/.cache/go-build make bin

FROM alpine

COPY --from=builder /tmp/wp-src/waypoint /usr/bin/waypoint

ENTRYPOINT ["/usr/bin/waypoint"]