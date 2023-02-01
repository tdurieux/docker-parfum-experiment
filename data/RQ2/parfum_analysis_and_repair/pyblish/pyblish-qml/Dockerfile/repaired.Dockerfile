# Usage:
#
# cd pyblish-qml
# docker run --rm -v $(pwd):/pyblish-qml pyblish/pyblish-qml

FROM ubuntu:18.04

MAINTAINER marcus@abstractfactory.io

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    git \
    python3-pyqt5* \
    python3-pip \
    python3-nose && \
    pip3 install --no-cache-dir \
        coverage && rm -rf /var/lib/apt/lists/*;

RUN mkdir /deps && cd /deps && \
    git clone https://github.com/pyblish/pyblish-base && \
    cd pyblish-base && git checkout 1.4.4

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONPATH=/deps/pyblish-base

WORKDIR /pyblish-qml
ENTRYPOINT nosetests3 \
    --verbose \
    --with-doctest \
    --exe \
    --exclude=vendor
