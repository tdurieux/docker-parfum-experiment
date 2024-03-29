#
# Composer Dependencies
#
FROM composer:2 as composer
WORKDIR /usr/local/src/
COPY auth.json composer.json composer.lock ./
RUN composer install --ignore-platform-reqs --no-scripts --no-autoloader --prefer-dist --no-dev --no-interaction
RUN cp -r /usr/local/src/vendor/laravel/horizon/public /usr/local/src/vendor/horizon

#
# Runtime
#
FROM php:8.0-fpm-alpine

ARG debug

USER root

RUN apk add --no-cache --update \
    # For zlib and gd extensions
    freetype \
    freetype-dev \
    jpeg-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libwebp-dev \
    zlib-dev \
    # For zip extension
    libzip-dev \
    # Extra modules
    git \
    jq \
    mysql-client \
    unzip \
    zip \
    # Nginx + Supervisor
    nginx \
    supervisor \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install exif gd mysqli opcache pcntl pdo_mysql zip \
    && rm -rf /tmp/*

RUN if [[ -z "$debug" ]] ; then { \
    echo 'opcache.enable_cli=1'; \
    echo 'opcache.validate_timestamps=0'; \
    echo 'opcache.revalidate_freq=2'; \
  } > /usr/local/etc/php/conf.d/docker-opcache.ini ; \
  fi

RUN { \
    echo 'log_errors=on'; \
    echo 'access.log=/dev/null;' \
    echo 'display_errors=off'; \
    echo 'upload_max_filesize=32M'; \
    echo 'post_max_size=32M'; \
    echo 'memory_limit=512M'; \
    echo 'expose_php=Off'; \
    echo 'max_input_time=-1'; \
    echo 'max_execution_time=300'; \
  } > /usr/local/etc/php/conf.d/docker-php.ini

RUN echo "* * * * * php /var/www/html/artisan schedule:run > /proc/1/fd/1" | crontab -

COPY .docker/nginx/default.conf /etc/nginx/http.d/default.conf

COPY .docker/nginx/supervisord.conf /etc/supervisord.conf

COPY --from=composer /usr/bin/composer /usr/bin/composer

COPY --chown=www-data --from=composer /usr/local/src/vendor ./vendor

COPY --chown=www-data ./ ./

RUN composer dumpautoload \
    && composer clearcache

EXPOSE 80

CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisord.conf" ]