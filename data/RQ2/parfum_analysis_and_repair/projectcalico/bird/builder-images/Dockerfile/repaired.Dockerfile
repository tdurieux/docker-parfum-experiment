FROM alpine:latest
MAINTAINER Tom Denham <tom@projectcalico.org>

RUN apk update
RUN apk add --no-cache alpine-sdk linux-headers autoconf flex bison ncurses-dev readline-dev

WORKDIR /code
