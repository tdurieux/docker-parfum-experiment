FROM alpine:3.8

RUN apk update && apk upgrade \
  && apk add --no-cache ca-certificates \
  && rm -rf /var/cache/apk/*
