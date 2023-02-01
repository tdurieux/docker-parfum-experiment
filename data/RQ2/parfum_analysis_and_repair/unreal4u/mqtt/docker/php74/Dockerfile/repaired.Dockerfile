FROM php:7.4-fpm

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apt-get update && apt-get install --no-install-recommends -y \
        libzip-dev \
        zip && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install zip