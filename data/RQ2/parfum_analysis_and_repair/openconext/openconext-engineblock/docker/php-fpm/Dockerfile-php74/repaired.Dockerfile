FROM php:7.4-fpm

ARG NPM_UID=1000
ARG NPM_GID=1000

# Copy phpfpm config
COPY docker/php-fpm/app.ini /usr/local/etc/php/conf.d/

# Yank the node and npm binaries from the official Node docker container
COPY --from=node:10 /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node:10 /usr/local/bin/node /usr/local/bin/node
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm
RUN npm install -g npx && npm cache clean --force;

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    python \
    zip \
    chromium \
    libpng-dev \
    && docker-php-ext-install pdo_mysql exif gd \
    ## APCu
    && pecl install xdebug \
    && pecl install apcu \
    && pecl install apcu_bc-1.0.3 \
    && docker-php-ext-enable apcu --ini-name 10-docker-php-ext-apcu.ini \
    && docker-php-ext-enable apc --ini-name 20-docker-php-ext-apc.ini && rm -rf /var/lib/apt/lists/*;

# Composer
COPY --from=composer:1 /usr/bin/composer /usr/local/bin/composer

# Fix npm
RUN mkdir /.npm && chown -R "${NPM_UID}:${NPM_GID}" "/.npm"
RUN mkdir /.config && chown -R "${NPM_UID}:${NPM_GID}" "/.config"

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /var/www

# Copy keys and config
COPY ci/qa-config/files/ /etc/openconext
