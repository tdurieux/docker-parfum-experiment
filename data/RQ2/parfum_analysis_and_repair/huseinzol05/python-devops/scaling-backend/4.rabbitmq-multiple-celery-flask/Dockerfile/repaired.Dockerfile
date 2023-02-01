FROM ubuntu:16.04 AS base

RUN apt-get update && apt-get install --no-install-recommends -y \
    python3 \
    python3-pip \
    wget \
    rabbitmq-server \
    supervisor && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir Flask celery flower

WORKDIR /app

COPY . /app
