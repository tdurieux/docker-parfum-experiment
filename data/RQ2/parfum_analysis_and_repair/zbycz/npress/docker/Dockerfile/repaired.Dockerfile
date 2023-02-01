FROM php:5.6-apache
RUN docker-php-ext-install mysqli pdo_mysql
RUN apt-get update \
    && apt-get install --no-install-recommends -y libzip-dev \
    && apt-get install --no-install-recommends -y zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install zip

# check rewrite in apachectl -M
RUN a2enmod rewrite
