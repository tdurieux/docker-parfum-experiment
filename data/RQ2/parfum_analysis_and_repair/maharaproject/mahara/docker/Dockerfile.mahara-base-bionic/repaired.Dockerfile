# Base Mahara image containing packages that are needed to build/test and
# run a Mahara instance
ARG BASE_UBUNTU=ubuntu:bionic
FROM ${BASE_UBUNTU}

# enviroment variable as non interactive
ARG DEBIAN_FRONTEND=noninteractive

# update packages
# Chromium is used for pdf exports and for behat tests
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        ca-certificates \
        chromium-browser \
        php-cli \
        php-curl \
        php-dom \
        php-gd \
        php-intl \
        php-json \
        php-ldap \
        php-mbstring \
        php-pgsql \
        php-redis \
        php-xmlrpc \
        php-zip \
        php-xml \
        curl && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /mahara/data && \
    chmod 777 /mahara/data

VOLUME /mahara/data
