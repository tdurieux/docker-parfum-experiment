# Read the PHP version to build for from the build arguments.
ARG PHP_VERSION

FROM composer:2 as composer

FROM php:${PHP_VERSION}-cli-alpine

# Install the XDebug extension that is current for the PHP version the image is being built for.
# XDebug 2.9.* on PHP 7.1 and below, XDebug 3.* on PHP 7.2 and above.
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
RUN install-php-extensions xdebug
# Some tests will complain if the timezone is not set; set it now.
RUN echo "date.timezone=UTC" >> /usr/local/etc/php/conf.d/docker-php-config.ini

# Configure XDebug.
ARG XDEBUG_REMOTE_HOST='host.docker.internal'
ARG XDEBUG_REMOTE_PORT='9009'
RUN echo $'xdebug.start_with_request=yes\n\
xdebug.mode=debug,develop\n\
xdebug.log_level=0\n\
xdebug.client_host='$XDEBUG_REMOTE_HOST$'\n\
xdebug.client_port='$XDEBUG_REMOTE_PORT$'\n' \
>> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# Output the PHP and XDebug version for build debugging purposes.