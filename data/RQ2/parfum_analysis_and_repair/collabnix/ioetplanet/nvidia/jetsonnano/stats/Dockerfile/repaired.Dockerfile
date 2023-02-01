cat Dockerfile
FROM python:3-alpine

RUN apk update \
    && apk --no-cache add bash \
    && pip install --no-cache-dir jetson-stats \
    && rm -rf /var/cache/apk/*
