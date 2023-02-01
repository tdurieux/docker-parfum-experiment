FROM debian:stretch-slim

RUN apt-get update \
  && apt-get install --no-install-recommends -y make g++ cmake git \
  && rm -rf /var/lib/apt/lists/*
