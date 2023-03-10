FROM php:7.3

RUN apt-get update && apt-get install --no-install-recommends -y libz-dev libmemcached-dev && rm -rf /var/lib/apt/lists/*;

RUN pecl install apcu && docker-php-ext-enable apcu --ini-name 10-docker-php-ext-apcu.ini
RUN pecl install memcached && docker-php-ext-enable memcached
RUN pecl install redis && docker-php-ext-enable redis

RUN docker-php-ext-install bcmath
RUN docker-php-ext-install pdo_mysql

COPY php-7.3.ini "$PHP_INI_DIR/php.ini"

# vim: ft=dockerfile
