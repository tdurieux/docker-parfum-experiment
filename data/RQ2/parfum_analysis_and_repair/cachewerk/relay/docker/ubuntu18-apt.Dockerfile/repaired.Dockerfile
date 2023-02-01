FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get install --no-install-recommends -y \
  curl \
  ca-certificates \
  apt-transport-https \
  software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository ppa:ondrej/php

RUN apt-get install --no-install-recommends -y \
  php8.1-fpm && rm -rf /var/lib/apt/lists/*;

# Add Relay repository
RUN curl -f -s "https://cachewerk.s3.amazonaws.com/repos/key.gpg" | apt-key add -
RUN add-apt-repository "deb https://cachewerk.s3.amazonaws.com/repos/deb $(lsb_release -cs) main"

# Install Relay
RUN apt-get install --no-install-recommends -y \
  php8.1-relay && rm -rf /var/lib/apt/lists/*;

## If no specific PHP version is installed just omit the version number:

# RUN apt-get install -y \
#  php-fpm \
#  php-relay
