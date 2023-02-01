FROM alpine:3.11
MAINTAINER Taro L. Saito <leo@xerial.org>

RUN apk --update --no-cache add bash gcc make perl libc-dev

WORKDIR /work
