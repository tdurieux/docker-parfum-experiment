FROM php:7.1-cli

RUN apt-get update && apt-get install --no-install-recommends -y \
    libmcrypt-dev && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install pdo_mysql mbstring mcrypt

RUN usermod -u 1000 www-data
WORKDIR /var/www/html
ENTRYPOINT ["php", "artisan"]