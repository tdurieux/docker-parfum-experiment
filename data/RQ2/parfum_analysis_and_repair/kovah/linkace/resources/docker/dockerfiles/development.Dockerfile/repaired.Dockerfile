# DOCKERFILE DEVELOPMENT
# Installs MySQL Client for database exports, xDebug with PCov and Composer

FROM php:7.4-fpm
WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends -y \
    zip \
    git \
    mariadb-client \
    autoconf \
    build-essential \
    libpq-dev \
    libzip-dev && rm -rf /var/lib/apt/lists/*;

RUN pecl install xdebug pcov
RUN docker-php-ext-install bcmath pdo_mysql pdo_pgsql zip
RUN docker-php-ext-enable xdebug pcov

RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

EXPOSE 10000
