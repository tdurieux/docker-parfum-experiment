FROM php:5.6-fpm-alpine

# Install stuff to build from PECL
RUN set -eux; \
    apk add --no-cache --virtual .build-deps \
        autoconf \
        file \
        g++ \
        gcc \
        make \
        pkgconf \
        re2c \
        curl-dev

# Install PDO MySQL + OPcache
RUN set -eux; \
    docker-php-ext-install -j$(nproc) pdo_mysql; \
    docker-php-ext-enable opcache

# Install Composer
RUN set -eux; \
    curl -f -q https://raw.githubusercontent.com/composer/getcomposer.org/1b137f8bf6db3e79a38a5bc45324414a6b1f9df2/web/installer | php -- php -- --filename=composer --install-dir=/usr/local/bin

# Install ddtrace
ARG ddtracePkgUrl
RUN set -eux; \
    cd ${HOME}; \
    curl -f -L "${ddtracePkgUrl}" -o ./signalfx_tracing.tgz; \
    pecl install signalfx_tracing.tgz; \
    echo "extension=signalfx-tracing.so" >  /usr/local/etc/php/conf.d/signalfx-tracing.ini
