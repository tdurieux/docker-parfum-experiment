FROM php:7.0.12-apache

RUN docker-php-ext-install pdo pdo_mysql

RUN apt-get update && apt-get install -y unzip

RUN a2enmod rewrite

COPY . /var/www

WORKDIR /var/www

RUN ./composer.phar install
