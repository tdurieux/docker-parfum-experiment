FROM php:7.0-apache

RUN apt-get update \
 && apt-get install --no-install-recommends -y git zlib1g-dev \
 && docker-php-ext-install zip \
 && a2enmod rewrite \
 && sed -i 's!/var/www/html!/var/www/public!g' /etc/apache2/apache2.conf \
 && mv /var/www/html /var/www/public \
 && curl -f -sS https://getcomposer.org/installer \
  | php -- --install-dir=/usr/local/bin --filename=composer && rm -rf /var/lib/apt/lists/*;

WORKDIR /var/www
