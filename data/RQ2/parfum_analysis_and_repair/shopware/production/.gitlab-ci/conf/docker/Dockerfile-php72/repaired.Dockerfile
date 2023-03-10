FROM php:7.2-cli-alpine3.10

ENV LD_PRELOAD=/usr/lib/preloadable_libiconv.so

RUN apk add --no-cache \
            libxml2 \
            libjpeg-turbo \
            libpng \
            libcurl \
            icu \
            libzip \
            gnu-libiconv \
    && apk add --no-cache --virtual build-deps \
            libxml2-dev \
            libjpeg-turbo-dev \
            libpng-dev \
            icu-dev \
            libzip-dev \
    && docker-php-ext-configure gd  --with-jpeg-dir=/usr/include \
    && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) gd \
    && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) intl \
    && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) mysqli \
    && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) pdo_mysql \
    && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) zip \
    && apk del build-deps

WORKDIR /sw6