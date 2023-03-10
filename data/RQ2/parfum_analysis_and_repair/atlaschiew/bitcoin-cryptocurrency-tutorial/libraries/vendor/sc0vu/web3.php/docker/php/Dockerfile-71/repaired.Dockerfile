FROM php:7.1.14-alpine

MAINTAINER Peter Lai <alk03073135@gmail.com>

ADD composer-setup.php composer-setup.php

RUN apk update && \
    apk add --no-cache git

# Install nodejs
# Run apk add --update nodejs nodejs-npm

# Install composer
RUN php composer-setup.php && \
    php composer-setup.php --install-dir=/usr/bin --filename=composer

WORKDIR /app