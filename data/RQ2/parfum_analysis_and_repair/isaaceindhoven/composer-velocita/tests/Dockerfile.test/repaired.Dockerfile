ARG PHP_VERSION
ARG COMPOSER_VERSION

# Composer base image - this works around the fact that `COPY --from=${var}` is not supported
FROM composer:${COMPOSER_VERSION} AS composer_base

# PHP image
FROM php:${PHP_VERSION}-cli-alpine3.14

LABEL maintainer="Jelle Raaijmakers <jelle@gmta.nl>"

ARG USER_UID

RUN apk --no-cache upgrade \
    && adduser -S -u ${USER_UID} testuser

RUN mkdir /test \
    && chown testuser /test \
    && mkdir /usr/src/velocita && rm -rf /usr/src/velocita
USER testuser
WORKDIR /test

COPY tests/testsuite.sh /usr/local/bin/

# Copy Velocita source
COPY composer.json /usr/src/velocita/
COPY src /usr/src/velocita/src/

COPY --from=composer_base /usr/bin/composer /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/testsuite.sh"]
