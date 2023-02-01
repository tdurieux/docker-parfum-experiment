FROM php:7.4-apache
LABEL maintainer="Alefe Souza <contact@alefesouza.com>"

RUN a2enmod rewrite

RUN apt-get update \
  && apt-get install --no-install-recommends -y libzip-dev unzip zlib1g-dev libicu-dev wget gnupg g++ git openssh-client libpng-dev iproute2 \
  && docker-php-ext-configure intl \
  && docker-php-ext-install intl pdo_mysql zip gd && rm -rf /var/lib/apt/lists/*;

RUN pecl install -f xdebug && docker-php-ext-enable xdebug;

RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash

RUN apt-get update \
  && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
