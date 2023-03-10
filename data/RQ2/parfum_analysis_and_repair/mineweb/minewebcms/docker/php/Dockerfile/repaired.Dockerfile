FROM php:7.4-apache

RUN apt-get update && apt-get install --no-install-recommends -y libicu-dev libzip-dev \
    libicu-dev zlib1g-dev libpng-dev libjpeg-dev \
    libfreetype6-dev libmcrypt-dev libpng-dev && rm -rf /var/lib/apt/lists/*;

RUN a2enmod rewrite

# Install MySQL PDO
RUN apt-get install --no-install-recommends -y libpq-dev \
    && docker-php-ext-install pdo pdo_mysql mysqli && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean

RUN pecl install apcu xdebug
RUN docker-php-ext-enable apcu xdebug
RUN docker-php-ext-install intl opcache zip iconv
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

COPY custom.ini $PHP_INI_DIR/conf.d/

WORKDIR /var/www/html