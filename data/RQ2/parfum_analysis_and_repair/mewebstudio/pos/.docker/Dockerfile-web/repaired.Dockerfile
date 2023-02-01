# Use image which contains apache with php
FROM php:7.2.5-apache

RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y

# Install packages needed to install php extensions
RUN apt-get install --no-install-recommends zlib1g-dev libxml2-dev libzip-dev zip unzip -y && rm -rf /var/lib/apt/lists/*;

# Install PHP extensions
RUN docker-php-ext-install zip

# Install XDEBUG
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Install composer command
RUN curl -f -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

#install nano text editor
RUN apt-get install -y --no-install-recommends nano && rm -rf /var/lib/apt/lists/*;

WORKDIR /var/www
