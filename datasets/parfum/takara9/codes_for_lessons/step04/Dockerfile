FROM php:7.0-apache
RUN apt-get update && apt-get install -y \
    && apt-get install -y libmcrypt-dev mysql-client \
    && apt-get install -y zip unzip git vim

RUN docker-php-ext-install pdo_mysql session json mbstring
COPY php/ /var/www/html/

