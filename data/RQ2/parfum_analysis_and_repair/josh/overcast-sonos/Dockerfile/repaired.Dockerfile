FROM php:7.2-apache

RUN apt-get update && apt-get install --no-install-recommends -y libxml2-dev \
    && docker-php-ext-install soap && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y libmemcached-dev zlib1g-dev \
    && pecl install memcached-3.0.4 \
    && docker-php-ext-enable memcached && rm -rf /var/lib/apt/lists/*;

RUN echo "date.timezone = UTC" > /usr/local/etc/php/conf.d/timezone.ini

COPY . /var/www/html/

EXPOSE 80
