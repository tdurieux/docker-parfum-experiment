###############################################################################
# BUILD STAGE

FROM golang:1.16-alpine AS build-env

WORKDIR /app

RUN set -x \
  && apk --no-cache --update add \
    bash \
    ca-certificates \
    git \
    make \
    upx

ADD https://docs.zyte.com/_static/zyte-smartproxy-ca.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

COPY . /app

RUN set -x \
  && make static

ARG upx=
RUN set -x \
  && if [ -n "$upx" ]; then \
    upx --ultra-brute -qq ./crawlera-headless-proxy; \
  fi


###############################################################################
# PACKAGE STAGE