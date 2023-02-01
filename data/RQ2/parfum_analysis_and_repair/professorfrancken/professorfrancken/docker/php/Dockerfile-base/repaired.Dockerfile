FROM composer:2.0 AS composer

FROM php:7.4.9-fpm

COPY --from=composer /usr/bin/composer /usr/bin/composer

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

RUN install-php-extensions zip gd redis igbinary apcu imagick \
    intl zip pdo_mysql pdo_pgsql soap opcache mysqli bcmath pcntl \
    pdo_sqlite mbstring

ADD imagemagick-policy.xml /etc/ImageMagick-6/policy.xml

WORKDIR /var/www/francken