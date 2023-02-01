FROM jakubboucek/lamp-devstack-php:5.6-legacy

LABEL org.label-schema.name="PHP 5.6 (Apache module + Xdebug)"

# Configure Xdebug
COPY legacy/xdebug-2.ini /usr/local/etc/php/conf.d/xdebug.ini

# Prevent interactive block
ARG DEBIAN_FRONTEND=noninteractive

# Install Xdebug
RUN set -eux; \
    pecl install xdebug-2.5.5; \
    docker-php-ext-enable xdebug; \
    rm -rf /var/tmp/* /tmp/*;