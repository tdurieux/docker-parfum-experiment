FROM alpine

RUN apk add --no-cache --update \
    jq curl \
    && rm -rf /var/cache/apk/*
