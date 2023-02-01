FROM ubuntu:16.04 AS base

ENV POSTGRES_USER root
ENV POSTGRES_PASSWORD root

RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    git \
    postgresql postgresql-contrib \
    python3 \
    python3-pip \
    python3-wheel && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

WORKDIR /app

COPY . /app
