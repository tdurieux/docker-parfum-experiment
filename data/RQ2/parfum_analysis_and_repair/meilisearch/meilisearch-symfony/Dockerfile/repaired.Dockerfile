FROM php:8.0-fpm as php

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER=1

RUN apt-get update && apt-get install --no-install-recommends -y \
        libfcgi0ldbl \
        zlib1g-dev \
        gettext \
        libzip-dev \
        unzip \
        git && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-install zip

CMD ["php-fpm"]
