ARG PHP_VERSION=7.4
FROM php:${PHP_VERSION}-cli

RUN pecl install pcov && docker-php-ext-enable pcov

# Install composer to manage PHP dependencies
RUN apt-get update && apt-get install --no-install-recommends -y git zip && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://getcomposer.org/download/2.0.8/composer.phar -o /usr/local/sbin/composer
RUN chmod +x /usr/local/sbin/composer
RUN composer self-update

WORKDIR /app
