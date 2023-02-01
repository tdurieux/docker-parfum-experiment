FROM php:7.3-fpm

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

# Pecl
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug


