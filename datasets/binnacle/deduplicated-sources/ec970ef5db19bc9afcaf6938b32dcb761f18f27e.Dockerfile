FROM php:5.5-fpm

MAINTAINER Mahmoud Zalt <mahmoud@zalt.me>

ADD ./laravel.ini /usr/local/etc/php/conf.d
ADD ./laravel.pool.conf /usr/local/etc/php-fpm.d/

RUN apt-get update && apt-get install -y \
    libpq-dev \
    libmemcached-dev \
    curl \
    --no-install-recommends \
    && rm -r /var/lib/apt/lists/*

# Install extensions using the helper script provided by the base image
RUN docker-php-ext-install \
    pdo_mysql \
    pdo_pgsql

# Install memcached
RUN pecl install memcached \
    && docker-php-ext-enable memcached

# Install xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Install mongodb driver
RUN pecl install mongodb

RUN usermod -u 1000 www-data

WORKDIR /var/www/laravel

CMD ["php-fpm"]

EXPOSE 9000
