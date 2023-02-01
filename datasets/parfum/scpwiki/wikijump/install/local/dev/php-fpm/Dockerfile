#
# PHP
#

FROM php:7.4-fpm-buster AS php

# Build variables
ARG ENVIRONMENT="local"
ARG DEBUG_IP="192.168.42.128"

ARG MAIN_DOMAIN="wikijump.localhost"
ARG FILES_DOMAIN="wjfiles.localhost"

# Derived variables
ARG WWW_DOMAIN="www.${MAIN_DOMAIN}"

# Copy setup scripts
RUN mkdir /src
COPY ./install/files/php-fpm/*.sh /src/

# Ensure PHP integer width is correct
RUN /src/check-php-int.sh

# Install system dependencies
RUN /src/setup-system.sh

# !! Add debug utilities
RUN apt install -y gdb valgrind vim

# !! Configure xdebug
RUN /src/setup-xdebug.sh
ARG XDEBUG_INI=/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# !! Put your IP for debugging here.
RUN echo "xdebug.mode = develop" >> ${XDEBUG_INI} \
    && echo "xdebug.client_host = ${DEBUG_IP}" >> ${XDEBUG_INI}

# Install composer from the official image
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Install PHP extensions, dependencies
WORKDIR /var/www/wikijump/web
RUN /src/setup-php-create.sh
RUN /src/setup-php-extensions.sh

USER www-data
COPY ./web/lib/ /var/www/wikijump/web/lib
COPY ./web/composer.json ./web/composer.lock /var/www/wikijump/web/
RUN /src/setup-php-dependencies.sh

# Copy PHP configuration files
COPY ./install/files/php-fpm/etc/php/ /usr/local/etc/php/conf.d/

# Copy full Wikijump source
COPY ./web /var/www/wikijump/web

# Inject values in the wikijump.ini and .env configuration files
USER root
COPY ./install/files/${ENVIRONMENT}/wikijump.ini conf/wikijump.ini
COPY ./install/files/${ENVIRONMENT}/php_env .env

RUN sed -i "s/%%BASE_DOMAIN%%/${MAIN_DOMAIN}/g" conf/wikijump.ini && \
    sed -i "s/%%MAIN_WIKI%%/${WWW_DOMAIN}/g" conf/wikijump.ini && \
    sed -i "s/%%FILE_DOMAIN%%/${FILES_DOMAIN}/g" conf/wikijump.ini

#
# Rust
#

FROM rust:latest AS rust

# Install mrml-cli for compiling MJML email templates
RUN cargo install --locked --version 1.3.2 mrml-cli

#
# Final image
#

FROM php
EXPOSE 9000

# Copy binaries from intermediate images
COPY --from=rust /usr/local/cargo/bin/mrml /usr/local/bin/mrml

# PHP configuration preparation
RUN php artisan key:generate
RUN php artisan config:cache
RUN /src/setup-misc.sh

# Install runner
COPY ./install/files/php-fpm/run.sh /app/run.sh

# Cleanup
# Don't remove composer for the local container

# We'll need to change the owner of the public directory,
# so that the user www-data can write to it.
RUN chown -R www-data /var/www/wikijump/web/public

USER www-data
ENTRYPOINT ["/app/run.sh"]
