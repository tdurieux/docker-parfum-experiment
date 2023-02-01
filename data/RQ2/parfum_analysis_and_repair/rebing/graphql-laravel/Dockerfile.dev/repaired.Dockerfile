FROM php:8.1.5-cli-alpine

COPY --from=mlocati/php-extension-installer:1.5.11 /usr/bin/install-php-extensions /usr/local/bin/

RUN install-php-extensions \
      xdebug && \
      rm /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

COPY --from=composer:2.3.5 /usr/bin/composer /usr/local/bin/

RUN mkdir /app

WORKDIR /app