# Nginx
FROM nginx:latest as nginx

LABEL traefik.enable="true"
LABEL traefik.http.services.todolist.loadbalancer.server.port="8000"
LABEL traefik.http.routers.todolist.entrypoints="websecure"
LABEL traefik.http.routers.todolist.rule="Host(`todolist-api.guillaumebriday.me`)"

COPY .cloud/nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY public /var/www/public

# Composer
FROM composer:1.10 as vendor

COPY database/ database/

COPY composer.json composer.json
COPY composer.lock composer.lock

RUN composer install \
    --ignore-platform-reqs \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --prefer-dist

# PHP
FROM php:7.3-fpm-stretch as application

LABEL maintainer="hello@guillaumebriday.fr"

WORKDIR /var/www

# Installing dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    mysql-client \
    libpng-dev \
    libzip-dev \
    locales \
    zip && rm -rf /var/lib/apt/lists/*;

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Installing extensions
RUN docker-php-ext-install pdo_mysql gd mbstring zip opcache

COPY . /var/www
COPY --from=vendor /app/vendor/ /var/www/vendor/

RUN chown -R www-data:www-data \
        /var/www/storage \
        /var/www/bootstrap/cache
