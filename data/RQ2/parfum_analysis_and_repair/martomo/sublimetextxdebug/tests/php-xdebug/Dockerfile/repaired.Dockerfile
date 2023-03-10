# Base of official Docker PHP images (https://hub.docker.com/_/php)
ARG PHP_VERSION=7.3
FROM php:${PHP_VERSION}-apache

# Download and compile Xdebug extension (https://pecl.php.net/package/xdebug)
ARG XDEBUG_VERSION=2.8.0
RUN pecl channel-update pecl.php.net && \
    pecl install xdebug-${XDEBUG_VERSION} && \
    # Enable Xdebug extension
    docker-php-ext-enable xdebug && \
    # Configure default Xdebug configuration for Docker image