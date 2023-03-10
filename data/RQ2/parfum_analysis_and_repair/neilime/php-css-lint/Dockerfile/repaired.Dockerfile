ARG VERSION=

FROM php:${VERSION}-cli

COPY --from=composer /usr/bin/composer /usr/local/bin/composer
RUN \
    apt-get update -yqq; \
    apt-get install --no-install-recommends -yqq unzip; rm -rf /var/lib/apt/lists/*; \
    pecl install pcov; \
    docker-php-ext-enable pcov;

RUN echo 'memory_limit = 512M' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini;

