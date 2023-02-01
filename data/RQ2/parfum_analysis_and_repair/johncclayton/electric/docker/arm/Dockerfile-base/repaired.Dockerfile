FROM hypriot/rpi-alpine:3.6 as base

LABEL maintainer="Neil Clayton, John Clayton" version="1.0"

WORKDIR /www
COPY ./src/server/requirements-base.txt /www
ENV MAKEFLAGS="-j 4"

RUN apk update \
    && apk add --no-cache bash zeromq py-pip python-dev linux-headers musl-dev gcc g++ libressl-dev openssl

RUN apk add --no-cache eudev-dev libusb gcc cython cython-dev libusb-dev

RUN pip install --no-cache-dir --upgrade setuptools \
    && pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir hidapi==0.7.99.post21 \
    && pip install --no-cache-dir -r requirements-base.txt \
    && rm -rf /www

# Intentionally not deleting compilers, because might be useful to non-base image
