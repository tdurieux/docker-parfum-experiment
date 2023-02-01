FROM php:7.3.18-cli
RUN apt-get update && apt-get install --no-install-recommends -y less git libgmp10-dev unzip && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-configure gmp && docker-php-ext-install -j$(nproc) gmp
RUN pecl install xdebug && docker-php-ext-enable xdebug
RUN curl -f https://getcomposer.org/download/1.9.1/composer.phar -s --output /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer
RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini
COPY toggle-ext /usr/local/bin/toggle-ext
RUN chmod +x /usr/local/bin/toggle-ext && toggle-ext xdebug
