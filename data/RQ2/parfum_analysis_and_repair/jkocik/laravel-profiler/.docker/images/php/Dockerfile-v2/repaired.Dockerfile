FROM php:8.0.6-fpm

COPY ./.bashrc-v2 /root/.bashrc

RUN apt-get update > /dev/null && apt-get install --no-install-recommends -y \
    acl \
    unzip \
    libzip-dev \
    zlib1g-dev \
    libpng-dev \
    libjpeg-dev \
    nodejs \
    redis-server && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-install zip pdo_mysql bcmath gd > /dev/null

RUN pecl install xdebug > /dev/null \
    && docker-php-ext-enable xdebug > /dev/null

RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer > /dev/null

RUN rm -rf /var/lib/apt/lists/*
