FROM php:7.1-apache

RUN apt-get update
RUN apt-get -y install wget \
    libxml2-dev \
    git \
    nano \
    libpng-dev \
    libmagickwand-dev \
    imagemagick \
    libgmp-dev \
    zlib1g-dev \
    ssmtp \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libgd-dev cron \
    msmtp \
    unzip \
    --no-install-recommends

WORKDIR /tmp/
ADD https://github.com/Jan-E/uploadprogress/archive/master.zip /tmp/
RUN unzip master.zip && cd /tmp/uploadprogress-master
WORKDIR /tmp/uploadprogress-master
RUN phpize
RUN ./configure
RUN make
RUN make install

RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

RUN docker-php-ext-install opcache
RUN docker-php-ext-install sockets

RUN pecl install imagick
RUN docker-php-ext-enable imagick
# Fixing "configure: error: Unable to locate gmp.h"
RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h

RUN docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install pdo_mysql gd mbstring gmp zip

RUN apt-get install -y \
    libmcrypt-dev \
    && docker-php-ext-install mcrypt \
    && apt-get remove -y \
    libmcrypt-dev \
    && apt-get install -y \
    libmcrypt4 \
    && apt-get autoremove -y

RUN apt-get install -y mysql-client

# Enable mod_rewrite
RUN a2enmod rewrite

# Install drush
RUN wget https://github.com/drush-ops/drush/releases/download/8.1.17/drush.phar
# Rename to `drush` instead of `php drush.phar`. Destination can be anywhere on $PATH.
RUN chmod +x drush.phar
RUN mv drush.phar /usr/local/bin/drush
# Test your install.
RUN drush core-status

# Configure for drupal install
COPY files/settings.php /var/www/html/sites/default/settings.php

# Enable error logging & msmtp
COPY files/php.ini /usr/local/etc/php/

RUN usermod -u 1000 www-data
RUN groupmod -g 1000 www-data
RUN chown -R www-data:www-data /var/www/html

# Clean up
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /var/www/html