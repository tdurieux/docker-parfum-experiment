FROM alpine:3

RUN apk add --no-cache \
  curl \
  git \
  jo \
  jq \
  make