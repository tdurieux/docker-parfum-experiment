# A base image for runtimes.
#
# This means that all Linkerd containers share a common set of tools, and furthermore, they
# are highly cacheable at runtime.

FROM debian:stretch-20190204-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        dnsutils \
        iptables \
        jq \
        nghttp2 \
    && rm -rf /var/lib/apt/lists/*
