FROM php:7.1-alpine

MAINTAINER Peter Lai <alk03073135@gmail.com>

COPY composer-setup.php composer-setup.php
# COPY php.ini-production $PHP_INI_DIR/php.ini

RUN apk update && \
    apk add --no-cache git

# Install gmp
Run apk add --no-cache gmp-dev && \
    docker-php-ext-install gmp

# Install nodejs
# Run apk add --update nodejs nodejs-npm

# Install composer
RUN php composer-setup.php && \
    php composer-setup.php --install-dir=/usr/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"

WORKDIR /app