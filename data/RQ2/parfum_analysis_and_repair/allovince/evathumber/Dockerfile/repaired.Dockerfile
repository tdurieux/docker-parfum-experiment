FROM php:7-apache-jessie

COPY . /var/www/html

RUN a2enmod rewrite \
    && apt-get update && apt-get install --no-install-recommends -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        zlib1g-dev \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && cp config.local.sample config.local.php \
    && chown -R www-data.www-data /var/www/html && rm -rf /var/lib/apt/lists/*;
