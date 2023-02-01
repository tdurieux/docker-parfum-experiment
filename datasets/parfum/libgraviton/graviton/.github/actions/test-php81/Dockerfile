FROM php:8.1-cli

ARG EXTMONGODB_VERSION=1.13.0
ARG EXTAMQP_VERSION=1.11.0

RUN apt update && \
    apt-get install -y librabbitmq-dev git zip unzip && \
    printf "\n" | pecl install -f mongodb-${EXTMONGODB_VERSION} && \
    printf "\n" | pecl install -f amqp-${EXTAMQP_VERSION} && \
    printf "\n" | pecl install -f pcov && \
    docker-php-ext-enable mongodb && \
    docker-php-ext-enable amqp && \
    apt clean

COPY --from=composer:2 --chown=www-data:root /usr/bin/composer /usr/local/bin/composer
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /usr/local/bin/composer /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
