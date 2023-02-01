FROM alpine
LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"

RUN apk add --no-cache --update \
    docker-cli \
    && rm -rf /var/cache/apk/*

VOLUME [ "/var/run/docker.sock" ]
