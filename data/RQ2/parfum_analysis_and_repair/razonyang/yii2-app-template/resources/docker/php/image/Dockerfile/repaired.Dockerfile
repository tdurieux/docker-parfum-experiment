FROM php:7.2-fpm
RUN apt-get update

# GD
RUN apt-get install --no-install-recommends -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd && rm -rf /var/lib/apt/lists/*;

# Intl
RUN apt-get install --no-install-recommends -y \
        zlib1g-dev \
        libicu-dev \
        g++ \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl && rm -rf /var/lib/apt/lists/*;

# MySQL
RUN docker-php-ext-install pdo_mysql

# PostgreSQL
RUN apt-get update && apt-get install --no-install-recommends -y \
        libpq-dev \
    && docker-php-ext-install pdo_pgsql && rm -rf /var/lib/apt/lists/*;

# ZIP
RUN docker-php-ext-install zip
