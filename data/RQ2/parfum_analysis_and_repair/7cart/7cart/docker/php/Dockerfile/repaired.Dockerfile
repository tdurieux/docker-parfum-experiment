FROM php:7.1-fpm

RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN apt-get update && apt-get install --no-install-recommends -y libpq-dev netcat git zip unzip && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-install pdo_pgsql

RUN usermod -u 1000 www-data

USER  www-data

ADD php.ini /usr/local/etc/php/conf.d/

WORKDIR /app