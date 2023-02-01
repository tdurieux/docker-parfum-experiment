FROM ubuntu:18.04

RUN set -x \
        && apt-get update \
        && apt-get install --no-install-recommends -y \
            iperf \
        && rm -rf /var/lib/apt/lists/*

