FROM php:5.6-apache

RUN a2enmod rewrite

RUN echo "date.timezone = Europe/London" > /usr/local/etc/php/conf.d/timezone.ini

# mcrypt
RUN apt-get update && apt-get install --no-install-recommends -y libmcrypt-dev && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install mcrypt
