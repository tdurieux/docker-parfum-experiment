FROM ubuntu:16.04 AS base

RUN apt-get update && apt-get install --no-install-recommends -y \
    python3 \
    python3-pip \
    python3-wheel \
    nginx && rm -rf /var/lib/apt/lists/*;

ADD . /code

WORKDIR /code

RUN pip3 install --no-cache-dir flask redis gunicorn eventlet
