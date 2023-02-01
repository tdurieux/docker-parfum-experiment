FROM ubuntu:16.04

# PHP version
ARG PHP_VERSION=7.2
ARG PROXY_IP=172.20.128.10
ARG PROXY_PORT=3128

RUN apt-get update -q -y
RUN apt-get upgrade -q -y
RUN apt-get install --no-install-recommends -q -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
RUN apt-get update
RUN apt-get install --no-install-recommends -q -y valgrind git vim cmake pkg-config curl gcc g++ zlib1g-dev jq lcov iptables && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -q -y language-pack-en-base software-properties-common && rm -rf /var/lib/apt/lists/*;

# Install PHP 7 from the third party repository
RUN apt-get install --no-install-recommends -y php${PHP_VERSION}-dev php${PHP_VERSION}-cli php${PHP_VERSION}-fpm php${PHP_VERSION}-json php${PHP_VERSION}-mysql php${PHP_VERSION}-readline && rm -rf /var/lib/apt/lists/*;

# Install Python Connector
RUN curl -f -O https://bootstrap.pypa.io/get-pip.py
RUN python3 get-pip.py
RUN pip install --no-cache-dir -U snowflake-connector-python

COPY iptables.txt /root

# Environmet variables for tests
ENV PHP_HOME=/usr
ENV http_proxy http://${PROXY_IP}:${PROXY_PORT}
ENV https_proxy http://${PROXY_IP}:${PROXY_PORT}
ENV HTTP_PROXY http://${PROXY_IP}:${PROXY_PORT}
ENV HTTPS_PROXY http://${PROXY_IP}:${PROXY_PORT}
