# Usage:
#
# cd pyblish-lite
# docker run --rm -v $(pwd):/pyblish-lite pyblish/pyblish-lite


FROM ubuntu:14.04

MAINTAINER marcus@abstractfactory.io

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    git \
    python-pyside \
    python-pip \
    python-nose && rm -rf /var/lib/apt/lists/*;

RUN mkdir /deps && cd /deps && \
    git clone https://github.com/pyblish/pyblish-base

ENV PYTHONPATH=/deps/pyblish-base

WORKDIR /pyblish-lite
ENTRYPOINT nosetests \
    --verbose \
    --with-doctest \
    --exe \
    --exclude=vendor
