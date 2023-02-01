FROM php:7-cli

RUN apt-get update -yqq \
    && apt-get install --no-install-recommends git zlib1g-dev libpq-dev libzip-dev -y \
    && docker-php-ext-install pdo pdo_pgsql zip && rm -rf /var/lib/apt/lists/*;

RUN curl -fsSL https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

RUN pecl install xdebug \
    &&  docker-php-ext-enable xdebug
