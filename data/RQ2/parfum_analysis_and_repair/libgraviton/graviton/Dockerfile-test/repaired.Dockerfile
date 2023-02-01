ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli

ARG EXTMONGODB_VERSION
ARG EXTAMQP_VERSION

COPY --from=composer:2 --chown=www-data:root /usr/bin/composer /usr/local/bin/composer

RUN apt update && \
    apt-get install --no-install-recommends -y librabbitmq-dev && \
    printf "\n" | pecl install -f mongodb-${EXTMONGODB_VERSION} && \
    printf "\n" | pecl install -f amqp-${EXTAMQP_VERSION} && \
    docker-php-ext-enable mongodb && \
    docker-php-ext-enable amqp && \
    chmod +x /usr/local/bin/composer && rm -rf /var/lib/apt/lists/*;
