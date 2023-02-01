FROM php:7.4-fpm-alpine

# Install PDO MySQL + OPcache
RUN set -eux; \
    docker-php-ext-install -j$(nproc) pdo_mysql; \
    docker-php-ext-enable opcache

# Install ddtrace
ARG ddtracePkgUrl
RUN set -eux; \
    cd ${HOME}; \
    curl -f -L "${ddtracePkgUrl}" -o ./ddtrace.apk; \
    apk add --no-cache ddtrace.apk --allow-untrusted;
