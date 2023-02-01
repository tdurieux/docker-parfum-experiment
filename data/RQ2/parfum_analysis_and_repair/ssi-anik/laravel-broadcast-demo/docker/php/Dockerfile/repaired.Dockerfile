FROM php:7.4-fpm

RUN apt-get update && apt-get install --no-install-recommends -y libpq-dev libpng-dev curl nano unzip zip git jq supervisor && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-install pdo_pgsql

RUN pecl install -o -f redis

RUN docker-php-ext-enable redis

RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY /docker/php/conf.ini /usr/local/etc/php/conf.d/custom.ini

WORKDIR /var/www/html