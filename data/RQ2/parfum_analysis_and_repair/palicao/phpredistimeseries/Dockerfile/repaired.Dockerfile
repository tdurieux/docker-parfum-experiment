FROM php:7.4-cli
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /app

ENV XDEBUG_MODE=coverage

RUN apt-get -y upgrade && \
    apt-get - dist-upgrade && \
    apt-get update && \
    apt-get install --no-install-recommends -yqq zip git wget && rm -rf /var/lib/apt/lists/*;

RUN pecl install redis && \
    pecl install xdebug && \
    docker-php-ext-enable redis xdebug

RUN wget https://github.com/composer/composer/releases/download/2.0.12/composer.phar -q && \
    mv composer.phar /usr/bin/composer && \
    chmod +x /usr/bin/composer
