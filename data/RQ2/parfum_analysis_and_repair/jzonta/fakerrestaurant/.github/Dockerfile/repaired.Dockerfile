FROM php:7.4-cli-alpine

WORKDIR /var/www

# Install bash
RUN apk add --no-cache \
 zip \
 unzip

# Install Composer
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN chown -R www-data:www-data /var/www
