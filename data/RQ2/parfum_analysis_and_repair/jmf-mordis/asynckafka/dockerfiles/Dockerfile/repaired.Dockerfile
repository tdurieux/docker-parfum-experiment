FROM python:3.7 AS builder

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    librdkafka-dev \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir kafka-python

ENV HOME /app
WORKDIR $HOME
