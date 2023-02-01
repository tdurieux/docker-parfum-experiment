FROM alpine:edge

RUN apk update && apk upgrade \
  && apk add --no-cache ca-certificates build-base boost \
  && rm -rf /var/cache/apk/*
