FROM python:3.7-alpine

LABEL Name="shadowsocksr" Maintainer="Ehco1996"

COPY requirements.txt /tmp/requirements.txt

RUN set -e; \
    apk update \
    && apk add --no-cache --virtual .build-deps gcc python3-dev musl-dev libffi-dev \
    # TODO workaround start
    && apk del libressl-dev \
    && apk add --no-cache openssl-dev \
    && apk del openssl-dev \
    && apk add --no-cache libressl-dev \
    # TODO workaround end
    && pip install --no-cache-dir -r /tmp/requirements.txt \
    && apk del .build-deps