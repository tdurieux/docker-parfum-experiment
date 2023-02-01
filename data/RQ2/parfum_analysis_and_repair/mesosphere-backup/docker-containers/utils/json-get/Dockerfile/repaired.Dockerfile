FROM alpine:3.1
MAINTAINER Mesosphere, Inc. <support@mesosphere.io>

RUN apk add --no-cache --update bash curl jq \
  && rm -rf /var/cache/apk/*

