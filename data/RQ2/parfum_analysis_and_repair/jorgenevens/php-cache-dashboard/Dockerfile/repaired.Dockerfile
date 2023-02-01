FROM php:7.2-apache

RUN apt-get update && \
        apt-get install --no-install-recommends -y libmemcached-dev zlib1g-dev && \
        pecl install redis memcached apcu && \
        docker-php-ext-enable redis memcached apcu && rm -rf /var/lib/apt/lists/*;

COPY "." "/var/www/html/"

EXPOSE 80/tcp
