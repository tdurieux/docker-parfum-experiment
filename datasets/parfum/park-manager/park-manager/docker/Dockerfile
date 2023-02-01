ARG PHP_VERSION=8.0


FROM php:${PHP_VERSION}-alpine

# persistent / runtime deps
RUN apk add --no-cache --virtual .persistent-deps \
        acl \
        file \
		git \
		libpq \
		postgresql-client \
		zlib \
		make

ARG APCU_VERSION=5.1.19
RUN set -eux; \
	apk add --no-cache --virtual .build-deps \
		$PHPIZE_DEPS \
		icu-dev \
		libzip-dev \
		postgresql-dev \
		zlib-dev \
	; \
	\
	docker-php-ext-configure zip; \
	docker-php-ext-install -j$(nproc) \
            pdo_pgsql \
	        pgsql \
        	bcmath \
	        intl \
	        zip \
	; \
	pecl install \
		apcu-${APCU_VERSION} \
	; \
	pecl clear-cache; \
	docker-php-ext-enable \
		apcu \
		opcache \
	; \
	\
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --no-cache --virtual .phpexts-rundeps $runDeps; \
	\
	apk del .build-deps

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN ln -s /usr/bin/composer /usr/bin/composer.phar

COPY php/conf.d/park-manager.ini $PHP_INI_DIR/conf.d/park-manager.ini

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER 1
# install Symfony Flex globally to speed up download of Composer packages (parallelized prefetching)
RUN set -eux; \
	composer global require "symfony/flex" --prefer-dist --no-progress --no-suggest --classmap-authoritative; \
	composer clear-cache
ENV PATH="${PATH}:/root/.composer/vendor/bin"

RUN set -eux; \
    wget https://github.com/infection/infection/releases/download/0.21.0/infection.phar; \
	chmod +x infection.phar; \
	mv infection.phar /usr/local/bin/infection

WORKDIR /srv/www

#RUN mkdir -p var/cache var/logs var/sessions \
#	&& composer dump-autoload --classmap-authoritative --no-dev \
#	&& chown -R www-data var
