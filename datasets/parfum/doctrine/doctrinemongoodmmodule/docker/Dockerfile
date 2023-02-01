ARG PHP_VERSION=7.2
FROM php:${PHP_VERSION}-alpine

ARG XDEBUG=0

COPY docker/entrypoint.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/entrypoint.sh

RUN apk add --no-cache \
    autoconf \
    bash \
    g++ \
    git \
    icu \
    icu-dev \
    icu-libs \
    libintl \
    libxml2-dev \
    make \
    openssl-dev
    
RUN docker-php-ext-configure intl
RUN docker-php-ext-install -j$(nproc) intl
RUN pecl install mongodb
RUN set -o pipefail && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN if [ ${XDEBUG} == "1" ] ; then pecl install xdebug && docker-php-ext-enable xdebug ; fi
RUN composer config --global "platform.ext-mongo" "1.6.16"

WORKDIR /docker
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
