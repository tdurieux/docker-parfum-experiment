FROM python:3.8.3-alpine3.11

RUN apk update \
 && apk add --no-cache \
    bash gcc git libffi libtool  openssl-dev openssh-client \
 && apk add --no-cache --virtual .build_deps build-base libffi-dev \
 && pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir virtualenv

 CMD ["/bin/sh"]
