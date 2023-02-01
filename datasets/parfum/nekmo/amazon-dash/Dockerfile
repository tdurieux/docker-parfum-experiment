FROM python:alpine
LABEL maintainer="Nekmo Com <contacto@nekmo.com>"

VOLUME /config

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN apk update \
    && apk add --no-cache --virtual build-dependencies \
      build-base \
      git \
    && apk add --no-cache \
      bash \
      libpcap \
      procps \
      tcpdump \
      tzdata \
    && git clone https://github.com/Nekmo/amazon-dash.git /usr/src/app \
    && pip install --no-cache-dir -r py3-requirements.txt \
    && pip install . \
    && python -m amazon_dash.install \
    && apk del build-dependencies \
    && rm -rf /var/cache/apk/*
