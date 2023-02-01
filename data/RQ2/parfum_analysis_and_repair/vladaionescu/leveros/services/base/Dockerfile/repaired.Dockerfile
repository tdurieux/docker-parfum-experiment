FROM alpine:3.3

LABEL com.leveros.isleveros="true"

RUN apk update && apk upgrade \
  && apk add --no-cache bash ca-certificates \
  && rm -rf /var/cache/apk/*
