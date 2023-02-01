# start with the official Composer image and name it
FROM composer:2 AS composer
# continue with the official PHP image
FROM php:7.3-fpm
# copy the Composer PHAR from the Composer image into the PHP image
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Prep for downloading Yarn
RUN apt-get update && apt-get install -y gnupg

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        libpq-dev \
        nodejs \
        yarn \
        libxslt1-dev \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install -j$(nproc) opcache \
    && docker-php-ext-install -j$(nproc) xsl \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install -j$(nproc) pdo pdo_pgsql pgsql

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"


# install xdebug
ARG XDEBUG_INI=/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN \
    pecl install xdebug; \
    docker-php-ext-enable xdebug; \
    echo "error_reporting = E_ALL" >> ${XDEBUG_INI}; \
    echo "display_startup_errors = yes" >> ${XDEBUG_INI}; \
    echo "xdebug.force_display_errors = 1" >> ${XDEBUG_INI}; \
    echo "xdebug.start_with_request = yes" >> ${XDEBUG_INI}; \
    echo "xdebug.discover_client_host = false" >> ${XDEBUG_INI}; \
    echo "xdebug.max_nesting_level = 1500" >> ${XDEBUG_INI};

WORKDIR /app
