FROM php:7.4-cli-alpine

RUN set -xe \
    && apk update \
    && apk add oniguruma-dev autoconf libpq postgresql-dev zlib-dev rabbitmq-c-dev make gcc g++ libzip-dev \
    && docker-php-ext-install \
        bcmath \
        pcntl \
        pgsql \
        pdo \
        pdo_pgsql \
        mbstring \
        sysvsem \
        zip \
    && pecl install amqp \
    && docker-php-ext-enable amqp \
	&& rm -rf /tmp/* /var/cache/apk/*

# Iconv fix
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# Composer install
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
   && chmod +x /usr/local/bin/composer \
   && composer global require hirak/prestissimo \
   && composer clear-cache

COPY ./tools/* /tools/

USER '1000'
