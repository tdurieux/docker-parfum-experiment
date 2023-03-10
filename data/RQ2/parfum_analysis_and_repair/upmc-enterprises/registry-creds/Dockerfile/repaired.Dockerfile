FROM alpine:3.4
MAINTAINER Steve Sloka <steve@stevesloka.com>

RUN apk add --no-cache --update ca-certificates && \
  rm -rf /var/cache/apk/*

COPY registry-creds registry-creds

ENTRYPOINT ["/registry-creds"]
