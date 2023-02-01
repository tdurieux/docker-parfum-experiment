FROM php:fpm

RUN apt-get update && apt-get install --no-install-recommends -y libpq-dev && docker-php-ext-install pdo pdo_pgsql && rm -rf /var/lib/apt/lists/*;

ADD ./ /var/www/html
