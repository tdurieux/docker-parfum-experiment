FROM        python:3-alpine

ENV         DEBIAN_FRONTEND noninteractive
ENV         PYTHONPATH /usr/local/src

RUN         apk add --no-cache --update \
                --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
                binutils build-base python3-dev gdal geos \
                && rm -rf /var/cache/apk/*

COPY        . /usr/local/src
WORKDIR     /usr/local/src
RUN pip install --no-cache-dir -U pip setuptools \
                && pip install --no-cache-dir -r requirements.txt

VOLUME      /usr/local/src
CMD         ["sh"]
