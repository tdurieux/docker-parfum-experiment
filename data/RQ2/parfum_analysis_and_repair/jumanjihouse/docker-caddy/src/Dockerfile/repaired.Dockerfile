# Must use go 1.9.0 or higher so "go get ./..." ignores the vendor folder.
# https://github.com/lucas-clemente/quic-go/issues/797
FROM golang:1.16.4-alpine3.13 as builder

ENV GOPATH /home/developer
ENV CGO_ENABLED 0
ENV GOOS linux
ENV GO111MODULE on

RUN apk add --no-cache \
      bash \
      binutils \
      file \
      git \
      openssl-dev \
      musl-dev \
      patch \
      scanelf \
      && :

RUN apk add --no-cache -X http://dl-4.alpinelinux.org/alpine/edge/main \
      'ca-certificates>=20190108-r0' \
      && :

RUN adduser -D developer

WORKDIR /home/developer

# This file is where we define the caddy version.
# The caddy version becomes part of the docker tag in Makefile.
COPY . /home/developer/
RUN chown --recursive developer /home/developer/main

# Compile caddy.
USER developer
RUN /home/developer/compile

################################################################################
# Build a runtime image.
################################################################################
FROM alpine:3.13.5

# Override the default false.
# https://caddyserver.com/blog/caddy-0_10_10-and-pricing
# https://caddyserver.com/docs/cli
ENV CASE_SENSITIVE_PATH=true

RUN apk upgrade --no-cache --available \
      && \
    apk add --no-cache \
      ca-certificates \
      git \
      openssl \
      openssh-client \
      && \
    adduser -Du 1000 caddy

RUN echo "hello world" > /home/caddy/index.html
COPY caddyfile /etc/caddy/

RUN \
    mkdir -p /var/www && \
    chown caddy:caddy /var/www && \
    :

COPY --from=builder /home/developer/bin/caddy /usr/sbin/caddy

# Run as an unprivileged user.