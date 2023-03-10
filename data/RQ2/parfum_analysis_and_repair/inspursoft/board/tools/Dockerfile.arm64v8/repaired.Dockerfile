FROM arm64v8/golang:1.13.5-alpine

MAINTAINER liyanqing@inspur.com

RUN apk update \
    && apk add --no-cache build-base\
    && rm -rf /var/cache/apk/*

ENV GO111MODULE=off