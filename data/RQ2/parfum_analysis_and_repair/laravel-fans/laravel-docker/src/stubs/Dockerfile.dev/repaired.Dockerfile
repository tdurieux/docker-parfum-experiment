# syntax = edrevo/dockerfile-plus

INCLUDE+ Dockerfile

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    git \
    vim \
    && apt-get clean \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# hadolint ignore=DL3059
RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini \
    && pecl install xdebug \
    && pecl clear-cache \
    && docker-php-ext-enable xdebug