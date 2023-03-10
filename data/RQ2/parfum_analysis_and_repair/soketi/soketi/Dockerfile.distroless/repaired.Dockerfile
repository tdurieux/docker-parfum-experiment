ARG VERSION=16

FROM node:$VERSION-alpine as base

ENV PYTHONUNBUFFERED=1

COPY . /tmp/build

WORKDIR /tmp/build

RUN apk add --no-cache --update git python3 gcompat && \
    apk add --no-cache --virtual build-dependencies build-base gcc wget && \
    ln -sf python3 /usr/bin/python && \
    python3 -m ensurepip && \
    pip3 install --no-cache-dir --no-cache --upgrade pip setuptools && \
    ash ./build-minimal-production && \
    mkdir -p /app && \
    cd /tmp/build && \
    mv production-app/* /app/ && \
    chgrp -R 0 /app/ && \
    chmod -R g+rx /app/ && \
    rm -rf /tmp/* /var/cache/* /usr/lib/python* && \
    apk --purge del build-dependencies build-base gcc

FROM gcr.io/distroless/nodejs:$VERSION

LABEL maintainer="Renoki Co. <alex@renoki.org>"

COPY --from=base /app /app

WORKDIR /app

USER 65534

EXPOSE 6001

CMD ["/app/bin/server.js", "start"]
