FROM php:5.6-fpm-alpine
MAINTAINER drupal-docker

RUN apk add --no-cache --virtual .dd-build-deps libpng-dev libjpeg-turbo-dev postgresql-dev libxml2-dev $PHPIZE_DEPS \
   && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
   && docker-php-ext-install gd mbstring pdo_mysql pdo_pgsql zip \
   && docker-php-ext-install opcache bcmath soap \
   && pecl install redis-2.2.8 \
   && docker-php-ext-enable redis \
   && apk add --no-cache libpng libjpeg libpq libxml2 \
   && apk del .dd-build-deps

COPY drupal-*.ini /usr/local/etc/php/conf.d/
