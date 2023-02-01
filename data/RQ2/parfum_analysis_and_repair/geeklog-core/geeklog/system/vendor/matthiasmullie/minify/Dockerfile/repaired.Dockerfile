ARG version=cli
FROM php:$version

COPY . /var/www
WORKDIR /var/www

RUN apt-get update && apt-get install --no-install-recommends -y zip unzip libzip-dev git && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install zip
RUN docker-php-ext-install pcntl
RUN pecl install xdebug || pecl install xdebug-2.7.2 || pecl install -f xdebug-2.5.5 && docker-php-ext-enable xdebug
RUN curl -f -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN composer install
