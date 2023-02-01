FROM php:5-apache
RUN apt-get update && apt-get install --no-install-recommends -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev && rm -rf /var/lib/apt/lists/*;

RUN a2enmod rewrite

RUN docker-php-ext-install -j$(nproc) mysqli mcrypt