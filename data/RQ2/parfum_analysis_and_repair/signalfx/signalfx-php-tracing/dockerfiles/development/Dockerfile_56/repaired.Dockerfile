FROM circleci/php:5.6-cli-stretch

USER root

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        vim \
        libssl-dev \
        libcurl4-gnutls-dev \
        libmemcached-dev \
        valgrind \
        mysql-client \
        libmcrypt-dev \
    && pecl install redis-4.3.0 \
    && docker-php-ext-enable redis \
    && pecl install memcached-2.2.0 \
    && docker-php-ext-enable memcached \
    && echo no | pecl install mongo-1.6.16 \
    && docker-php-ext-enable mongo \
    && docker-php-ext-install mysqli pdo pdo_mysql \
    && docker-php-ext-install mcrypt \
    && docker-php-source delete \
    && rm -rf /var/lib/apt/lists/*

COPY dockerfiles/development/dd-test-env.ini /usr/local/etc/php/conf.d/dd-test-env.ini

USER circleci

CMD bash
