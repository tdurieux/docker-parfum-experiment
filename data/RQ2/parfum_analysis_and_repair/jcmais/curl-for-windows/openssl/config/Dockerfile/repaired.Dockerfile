FROM ubuntu:20.04

VOLUME /node

RUN buildDeps='binutils build-essential vim nasm git' \
  && apt-get update \
  && apt-get install -y --no-install-recommends --force-yes $buildDeps \
  && apt-get clean \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /node