FROM ubuntu:18.04

# PHP version
ARG PHP_VERSION=7.2

RUN apt-get update -q -y
RUN apt-get upgrade -q -y
RUN apt-get install --no-install-recommends -y valgrind git vim cmake pkg-config curl gcc g++ zlib1g-dev jq lcov && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y language-pack-en-base software-properties-common && rm -rf /var/lib/apt/lists/*;

# Install PHP 7 from the third party repository
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y php${PHP_VERSION}-dev php${PHP_VERSION}-cli php${PHP_VERSION}-fpm php${PHP_VERSION}-json php${PHP_VERSION}-mysql php${PHP_VERSION}-readline && rm -rf /var/lib/apt/lists/*;

# Install Python Connector
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -U pip
RUN pip install --no-cache-dir -U snowflake-connector-python

# Environmet variables for tests
ENV PHP_HOME=/usr
