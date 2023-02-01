ARG image_php

FROM ${image_php} AS php

RUN apk add --no-cache \
		acl \
		file \
		gettext \
		git \
	;

ARG icu
COPY files/icu-${icu}.tgz /tmp/icu.tgz

RUN set -eux; \
	apk add --no-cache --virtual .build-deps \
		${PHPIZE_DEPS} \
		icu-dev \
		libzip-dev \
		mysql-dev \
		zlib-dev \
	; \
	\
	tar -zxf /tmp/icu.tgz -C /tmp; \
	cd /tmp/icu/source; CXXFLAGS="--std=c++0x" ./runConfigureICU Linux && make && make install; cd -; \
	rm -rf /tmp/icu /tmp/icu.tgz; \
	\
	docker-php-ext-configure intl; \
	docker-php-ext-configure zip --with-libzip; \
	docker-php-ext-install -j$(nproc) \
		intl \
		bcmath \
		pdo_mysql \
		zip \
	; \
	docker-php-ext-enable \
		opcache \
	; \
	\
	run_deps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --no-cache --virtual .app-phpexts-rundeps ${run_deps}; \
	\
	apk del .build-deps

COPY conf.d/symfony.ini "${PHP_INI_DIR}/conf.d/"

ENV COMPOSER_HOME=/composer
ENV COMPOSER_CACHE_DIR=/composer/cache
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_HTACCESS_PROTECT=0
COPY --from=composer /usr/bin/composer /usr/bin/
COPY composer/composer.json /composer/
COPY composer/config.json /composer/

ARG staging_env

RUN if [ "${staging_env}" = 'dev' ]; then ln -s php.ini-development "${PHP_INI_DIR}/php.ini"; \
	else ln -s php.ini-production "${PHP_INI_DIR}/php.ini"; fi

RUN set -eux; \
	composer global install --prefer-dist --no-progress --no-interaction --no-suggest --classmap-authoritative; \
	composer clear-cache

ARG run_uid

RUN if [ -n "${run_uid}" ]; then \
		sed -i "s/user = www-data/user = ${run_uid}/" /usr/local/etc/php-fpm.d/www.conf; \
		chown -R "${run_uid}" /composer; \
	fi

ARG run_gid

RUN if [ -n "${run_gid}" ]; then \
		sed -i "s/group = www-data/group = ${run_gid}/" /usr/local/etc/php-fpm.d/www.conf; \
		chown -R ":${run_gid}" /composer; \
	fi
