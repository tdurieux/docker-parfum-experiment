FROM jakzal/phpqa:alpine

## Required for Composer
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
##

COPY qa/tools.json $TOOLBOX_TARGET_DIR/extra-tools.json

RUN php $TOOLBOX_TARGET_DIR/toolbox install --tools $TOOLBOX_TARGET_DIR/extra-tools.json \
  && rm -rf ~/.composer/cache

RUN wget -O composer-normalize https://github.com/ergebnis/composer-normalize/releases/download/2.9.0/composer-normalize.phar \
   && chmod +x composer-normalize \
   && mv composer-normalize $TOOLBOX_TARGET_DIR/.composer/vendor/bin

ENV TOOLBOX_JSON="phar://$TOOLBOX_TARGET_DIR/toolbox/resources/pre-installation.json,phar://$TOOLBOX_TARGET_DIR/toolbox/resources/tools.json,$TOOLBOX_TARGET_DIR/extra-tools.json"