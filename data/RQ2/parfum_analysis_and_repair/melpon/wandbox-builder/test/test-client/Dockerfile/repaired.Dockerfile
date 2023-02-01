FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
      curl \
      python-minimal \
      python-requests && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
