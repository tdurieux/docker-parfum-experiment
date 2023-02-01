FROM php:7.0-apache
RUN apt-get update && apt-get install -y \
    && apt-get install --no-install-recommends -y libmcrypt-dev mysql-client \
    && apt-get install --no-install-recommends -y zip unzip git vim && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-install pdo_mysql session json mbstring
COPY php/ /var/www/html/

