FROM alpine:3.11

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >>/etc/apk/repositories
RUN apk update && apk add --no-cache kubectl && rm -rf /var/cache/apk/*
