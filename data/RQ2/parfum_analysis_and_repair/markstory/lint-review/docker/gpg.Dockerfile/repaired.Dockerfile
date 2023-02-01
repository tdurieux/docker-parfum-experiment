FROM alpine:3.7

RUN mkdir /src \
  && mkdir /tool \
  && apk update \
  && apk add --no-cache gnupg \
  && rm -rf /var/cache/apk/*

WORKDIR /src
