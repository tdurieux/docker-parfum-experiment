FROM ubuntu:18.04

ENV CONFLUENT_HOME=/usr \
    TERM=xterm-256color

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        git \
        curl \
        wget \
        jq \
        netcat \
        httpie \
        peco \
        vim \
        expect \
    && curl -f --http1.1 -L https://cnfl.io/cli | sh -s -- -b /usr/bin v2.3.1 \
    && rm -rf /var/lib/apt/lists/*
