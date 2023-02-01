# build stage
FROM caddy:2.2.1-builder-alpine as builder

RUN apk add --no-cache git gcc musl-dev wget

COPY . /tmp/caddy-s3browser

RUN \
    xcaddy build --with github.com/techknowlogick/caddy-s3browser=/tmp/caddy-s3browser && \
    /usr/bin/caddy version && \
    /usr/bin/caddy list-modules | grep s3browser && \
    mkdir -p /install && \
    cp /usr/bin/caddy /install/caddy
# last copy command is for backwards compatibility