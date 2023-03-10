FROM php:7.0.4-fpm
RUN apt-get update && apt-get install -y libmcrypt-dev \
    mysql-client libmagickwand-dev --no-install-recommends \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && mv ./.dockerignore-dev ./.dockerignore \
    && docker-php-ext-install mcrypt pdo_mysql && rm -rf /var/lib/apt/lists/*;
