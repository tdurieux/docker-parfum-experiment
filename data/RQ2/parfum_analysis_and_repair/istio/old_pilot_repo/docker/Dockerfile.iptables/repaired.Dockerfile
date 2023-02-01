FROM ubuntu:xenial
RUN apt-get update && apt-get install --no-install-recommends -y \
    iptables \
 && rm -rf /var/lib/apt/lists/*
