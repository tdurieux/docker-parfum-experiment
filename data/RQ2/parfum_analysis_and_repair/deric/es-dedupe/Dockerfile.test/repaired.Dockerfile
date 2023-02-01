FROM debian:10-slim as builder
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq && apt-get install --no-install-recommends -y python3-pip python3-setuptools python3-dev make g++\
 && apt-get clean && rm -rf /var/lib/apt/lists/*
ADD requirements-dev.txt /tmp/
RUN pip3 install --no-cache-dir wheel && pip3 install --no-cache-dir -r /tmp/requirements-dev.txt
RUN mkdir /app
WORKDIR /app
