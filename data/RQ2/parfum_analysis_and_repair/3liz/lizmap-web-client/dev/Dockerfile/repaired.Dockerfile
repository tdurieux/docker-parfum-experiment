FROM ubuntu:20.04

LABEL Maintainer="3Liz"

ARG COMPOSER_VERSION=2.3.7
ARG PHP_VERSION=8.1

ENV PHP_VERSION=${PHP_VERSION}

RUN set -eux; \
    export DEBIAN_FRONTEND=noninteractive && dpkg-divert --local --rename --add /sbin/initctl; \
    apt-get update; \
    apt-get upgrade -y; \
    apt-get -y --no-install-recommends install apt-transport-https lsb-release ca-certificates curl wget; rm -rf /var/lib/apt/lists/*; \
    apt-get update; \
    apt-get clean;

RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y --no-install-recommends \
        make \
        git \
        zip \
        php${PHP_VERSION}-cli \
        php${PHP_VERSION}-zip \
        php${PHP_VERSION}-curl \
        php${PHP_VERSION}-intl \
        php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-xml \
    ; rm -rf /var/lib/apt/lists/*; sed -i "/^display_errors =/c\display_errors = On" /etc/php/${PHP_VERSION}/cli/php.ini \
    ; apt-get clean

#install nodejs and npm to build js files
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

## Install Composer
RUN wget -O /bin/composer https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar \
    && chmod +x /bin/composer

