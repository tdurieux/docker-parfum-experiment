FROM php:8.0-fpm

COPY --from=composer:2.0.4 /usr/bin/composer /usr/bin/composer

COPY . .

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libzip-dev zip && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-configure zip
RUN docker-php-ext-install zip

RUN composer install

CMD php tests/zen-circus/php8/polling.php
