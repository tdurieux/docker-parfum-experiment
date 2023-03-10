FROM composer:1.8
FROM php:7.2-fpm-alpine

COPY ./docker/php/dev/development.ini /usr/local/etc/php/conf.d/development.ini

WORKDIR /var/www/app

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN apk upgrade -q -U -a \
    && apk add --no-cache \
		git \
		icu-libs \
		openssh \
        libssh2 \
        libssh2-dev

RUN set -xe \
	&& apk add --no-cache --virtual .build-deps \
		$PHPIZE_DEPS \
		icu-dev \
		freetype-dev \
        libzip-dev \
    && pecl install redis-4.1.1 \
    && pecl install ssh2-1.1.2 \
	&& docker-php-ext-install \
		mbstring \
		zip \
		pdo \
		pdo_mysql \
	&& pecl install apcu-5.1.17 \
	&& pecl install xdebug-2.7.0RC2 \
	&& docker-php-ext-enable --ini-name 20-apcu.ini apcu \
	&& docker-php-ext-enable --ini-name 05-opcache.ini opcache \
	&& docker-php-ext-enable redis \
	&& docker-php-ext-enable ssh2 \
	&& docker-php-ext-enable xdebug

COPY --from=0 /usr/bin/composer /usr/bin/composer