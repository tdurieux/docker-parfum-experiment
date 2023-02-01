FROM python:3.5.5-alpine
MAINTAINER chie hayashida<chie8842@gmail.com>

RUN apk update \
    && apk add --no-cache sqlite \
    && apk add --no-cache socat \
    && apk add --no-cache git

RUN pip install --no-cache-dir pytest

WORKDIR /tmp/work

