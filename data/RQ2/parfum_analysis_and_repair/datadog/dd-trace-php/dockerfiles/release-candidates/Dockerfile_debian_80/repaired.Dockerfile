FROM php:8.0-rc-fpm-buster

# Install PDO MySQL + OPcache
RUN set -eux; \
    docker-php-ext-install -j$(nproc) pdo_mysql; \
    docker-php-ext-enable opcache

# Install ddtrace
ARG ddtracePkgUrl
RUN set -eux; \
    cd ${HOME}; \
    curl -f -L "${ddtracePkgUrl}" -o ./ddtrace.deb; \
    dpkg -i ddtrace.deb;
