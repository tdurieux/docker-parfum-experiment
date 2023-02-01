FROM php:7.1.4-fpm

RUN apt-get -qq update \
    && apt-get -qq -y --no-install-recommends install libxml2-dev libpq-dev \
    && docker-php-ext-install pdo xml pgsql && rm -rf /var/lib/apt/lists/*;

COPY php-fpm/www.conf /etc/php-fpm.d/www.conf
