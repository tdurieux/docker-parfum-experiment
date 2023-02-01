FROM php:8.0-cli

RUN apt-get update && curl -f -sS https://getcomposer.org/installer | php \
			&& mv composer.phar /usr/local/bin/composer \
			&& apt-get install --no-install-recommends git unzip -y && rm -rf /var/lib/apt/lists/*; ## PHP dependencies
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug
# composer



ENV COMPOSER_ALLOW_SUPERUSER=1
ENV XDEBUG_MODE=coverage
WORKDIR /src