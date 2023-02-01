FROM demoregistry.dataman-inc.com/library/alpine3.3-base:latest

RUN apk add --no-cache --update python && rm -rf /var/cache/apk/*
