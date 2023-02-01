FROM php:8.0-fpm-alpine

LABEL maintainer="Portabilis <contato@portabilis.com.br>"

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_PROCESS_TIMEOUT 900
ENV COMPOSER_DISABLE_XDEBUG_WARN=1

ENV XDEBUG_IDEKEY xdebug
ENV XDEBUG_CLIENT_HOST 127.0.0.1
ENV XDEBUG_CLIENT_PORT 9003
ENV XDEBUG_MODE off
ENV XDEBUG_START_WITH_REQUEST off

RUN apk update
RUN apk add --no-cache wget

RUN apk add --no-cache --virtual .phpize_deps $PHPIZE_DEPS

RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

RUN apk --no-cache add postgresql-dev
RUN docker-php-ext-install pgsql

RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_pgsql

RUN pecl install redis
RUN docker-php-ext-enable redis
RUN rm -rf /tmp/pear

RUN docker-php-ext-install bcmath

RUN apk add --no-cache unzip

RUN apk add --no-cache libzip-dev
RUN docker-php-ext-install zip

RUN apk add --no-cache libc-dev

RUN echo "@v3.4 http://nl.alpinelinux.org/alpine/v3.4/main" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache "postgresql-client@v3.4>=9.5"

RUN apk add --no-cache postgresql-client

RUN apk add --no-cache libpng-dev
RUN docker-php-ext-install gd

RUN apk add --no-cache jq git

RUN ln -s /var/www/ieducar/artisan /usr/local/bin/artisan

RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

RUN docker-php-ext-install pcntl

RUN apk add --no-cache openjdk8
RUN apk add --no-cache ttf-dejavu

RUN apk add --no-cache --update npm

RUN composer self-update

RUN apk del .phpize_deps
