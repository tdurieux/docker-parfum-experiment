FROM php:8.1-fpm-alpine

RUN curl -f -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /app
