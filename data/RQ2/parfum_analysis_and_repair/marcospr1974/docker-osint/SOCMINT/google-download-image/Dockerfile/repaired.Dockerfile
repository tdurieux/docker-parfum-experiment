FROM python:3.7-alpine

MAINTAINER Marcos Pablo Russo <marcospr1974@gmail.com>

RUN apk update \
    && apk add --no-cache git \
    && git clone https://github.com/Joeclinton1/google-images-download.git \
    && cd  /google-images-download \
    && pip3 install --no-cache-dir -r requirements.txt \
    && python setup.py install \
    && mkdir /downloads

VOLUME /downloads

ENTRYPOINT ["googleimagesdownload"]
