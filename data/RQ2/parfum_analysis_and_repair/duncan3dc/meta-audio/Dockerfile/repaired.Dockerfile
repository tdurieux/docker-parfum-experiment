ARG PHP_VERSION=7.2
FROM php:${PHP_VERSION}-cli

ARG COVERAGE
RUN if [ "$COVERAGE" = "pcov" ]; then pecl install pcov && docker-php-ext-enable pcov; fi

# Install composer to manage PHP dependencies
RUN apt-get update && apt-get install --no-install-recommends -y git zip && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://getcomposer.org/download/1.10.6/composer.phar -o /usr/local/sbin/composer
RUN chmod +x /usr/local/sbin/composer
RUN composer self-update

WORKDIR /app
