FROM ubuntu:12.04

ENV VERSION 0.3.4
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;

# Stubs
WORKDIR /root
RUN curl -f -Lo- https://github.com/ouspg/trytls/archive/v${VERSION}.tar.gz | \
  zcat | tar --strip-components=1 -xvf - trytls-${VERSION}/stubs

# Go
RUN apt-get -y --no-install-recommends install golang-go && rm -rf /var/lib/apt/lists/*;
WORKDIR /root/stubs/go-nethttp
RUN go build run.go

# Java too old to compile the stubs in Ubuntu 12.04 LTS

# Python 2
RUN apt-get -y --no-install-recommends install python-requests && rm -rf /var/lib/apt/lists/*;

# Python 3
RUN apt-get -y --no-install-recommends install python3 && rm -rf /var/lib/apt/lists/*;

# PHP
RUN apt-get -y --no-install-recommends install php5 && rm -rf /var/lib/apt/lists/*;

# Default workdir for easier manual stub testing
WORKDIR /root/stubs/
