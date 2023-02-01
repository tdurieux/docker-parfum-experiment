ARG PHP_VERSION
FROM php:$PHP_VERSION
RUN apt-get update \
    && apt-get install --no-install-recommends -y libffi-dev git unzip \
    && docker-php-source extract \
    && docker-php-ext-install ffi \
    && docker-php-source delete && rm -rf /var/lib/apt/lists/*;
WORKDIR /usr/src/z-engine
RUN curl -f -sS https://getcomposer.org/installer | php && mv ./composer.phar /usr/local/bin/composer
COPY . /usr/src/z-engine
RUN composer install