# Dockerfile content
FROM alpine:3.8
MAINTAINER "Put your name"
RUN apk update
RUN apk add --no-cache memcached
ENTRYPOINT ["/usr/bin/memcached" ]
