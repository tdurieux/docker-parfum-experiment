FROM php:7.2-fpm

MAINTAINER Ankit Jain <ankitjain28may77@gmail.com>


RUN apt-get update && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y python-setuptools \
    curl \
    git \
    nano \
    sudo \
    unzip \
    openssh-server \
    openssl \
    supervisor \
    memcached \
    ssmtp \
    cron && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libxml2-dev && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) pdo_mysql soap mysqli mbstring zip

# Cleanup
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

EXPOSE 80 3306 22

WORKDIR /var/www/html/drupal

