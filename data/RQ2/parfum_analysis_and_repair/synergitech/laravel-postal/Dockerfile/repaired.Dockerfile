ARG PHP_VERSION=7.3
FROM php:$PHP_VERSION-cli-alpine

RUN apk add --no-cache git zip unzip autoconf make g++

RUN pecl install xdebug && docker-php-ext-enable xdebug

RUN curl -f -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

WORKDIR /package

COPY composer.json ./

ARG LARAVEL=7
RUN composer require laravel/framework ^$LARAVEL.0

COPY . .

RUN XDEBUG_MODE=coverage composer test
