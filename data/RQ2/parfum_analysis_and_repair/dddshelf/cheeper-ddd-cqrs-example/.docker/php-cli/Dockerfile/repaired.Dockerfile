FROM php:8.1-cli

RUN apt-get update \
    && apt-get -y --no-install-recommends install librabbitmq-dev \
                          $PHPIZE_DEPS \
    && docker-php-ext-install pdo_mysql mysqli pcntl \
    && pecl install redis \
    && pecl install amqp \
    && docker-php-ext-enable redis amqp && rm -rf /var/lib/apt/lists/*;