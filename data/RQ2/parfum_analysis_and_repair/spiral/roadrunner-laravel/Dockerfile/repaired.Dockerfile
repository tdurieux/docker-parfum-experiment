# Image page: <https://hub.docker.com/_/php>
FROM php:8.1.7-alpine

ENV COMPOSER_HOME="/tmp/composer"

# Image page: <https://hub.docker.com/_/composer>
COPY --from=composer:2.2.6 /usr/bin/composer /usr/bin/composer

# Image page: <https://hub.docker.com/r/spiralscout/roadrunner>
COPY --from=spiralscout/roadrunner:2.7.6 /usr/bin/rr /usr/bin/rr

RUN set -x \
    && apk add --no-cache binutils git \
    && apk add --no-cache --virtual .build-deps autoconf pkgconf make g++ gcc 1>/dev/null \
    # install xdebug (for testing with code coverage), but do not enable it
    && pecl install xdebug-3.1.2 1>/dev/null \
    # install PHP extensions (CFLAGS usage reason - https://bit.ly/3ALS5NU)