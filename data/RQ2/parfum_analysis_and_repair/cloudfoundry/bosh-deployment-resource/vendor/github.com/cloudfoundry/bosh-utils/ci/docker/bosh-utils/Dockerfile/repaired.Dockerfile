FROM golang:1

RUN \
  apt-get update \
  && apt-get install --no-install-recommends -y \
    lsof \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
