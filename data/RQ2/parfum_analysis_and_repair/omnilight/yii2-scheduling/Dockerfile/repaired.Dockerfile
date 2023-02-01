FROM composer

FROM php:5.4-cli

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        git \
        unzip && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-install mbstring

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN composer global require hirak/prestissimo

WORKDIR /app

COPY composer.json .

RUN composer install --prefer-dist --no-interaction --no-ansi

COPY . .
