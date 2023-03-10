# phpexperts/web-debug
ARG PHP_VERSION=7.4
FROM phpexperts/php:${PHP_VERSION}-debug

RUN apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
        ca-certificates \
        nginx \
        supervisor && \

    # Route nginx logs to syslog socket (will show in Docker logs)
    sed -i 's!/var/log/nginx/access.log!syslog:server=unix:/dev/log!g' /etc/nginx/nginx.conf && \
    sed -i 's!/var/log/nginx/error.log!syslog:server=unix:/dev/log!g' /etc/nginx/nginx.conf && \
    ln -s /usr/sbin/php-fpm* /usr/sbin/php-fpm && \

    # Cleanup