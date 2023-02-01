FROM postgres:10.15-alpine

RUN apk add --no-cache --update \
    ca-certificates \
  && rm -rf /var/cache/apk/*
