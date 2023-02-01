# Base Mahara image containing packages that are needed to build/test and
# run a Mahara instance
ARG BASE_UBUNTU=ubuntu:focal
FROM ${BASE_UBUNTU}

# enviroment variable as non interactive
ARG DEBIAN_FRONTEND=noninteractive

# update packages

# RUN apt-get update && \
#     apt-get install -y \
#         curl \
#         gnupg2

# Google Chrome stable for Behat headless testing
# RUN curl -s https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
#     echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main'>> /etc/apt/sources.list.d/google-chrome.list && \
#     apt-get update && \
#     apt-get install -y \
#         google-chrome-stable

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
        php-xdebug \
        openjdk-8-jre-headless \
        curl \
        lsof && rm -rf /var/lib/apt/lists/*;

COPY docker/web/etc/php/7.4/apache2/conf.d/20-xdebug.ini /etc/php/7.4/apache2/conf.d/20-xdebug.ini
COPY docker/web/etc/php/7.4/cli/conf.d/20-xdebug.ini /etc/php/7.4/cli/conf.d/20-xdebug.ini

RUN mkdir -p /mahara/data && \
    chmod 777 /mahara/data

VOLUME /mahara/data
