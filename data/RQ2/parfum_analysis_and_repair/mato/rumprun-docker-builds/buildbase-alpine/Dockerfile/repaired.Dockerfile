FROM alpine:latest
MAINTAINER Martin Lucina <martin@lucina.net>
RUN apk add --no-cache --update gcc g++ make libc-dev && rm -rf /var/cache/apk/*
