# the different stages of this Dockerfile are meant to be built into separate images
# https://docs.docker.com/develop/develop-images/multistage-build/#stop-at-a-specific-build-stage
# https://docs.docker.com/compose/compose-file/#target

ARG NODE_VERSION=14
ARG PHP_VERSION=8.1
ARG CADDY_VERSION=2
#=======================================================================
FROM node:${NODE_VERSION}-alpine AS salt_core_js_build

USER node
WORKDIR /srv/core

COPY package.json yarn.lock ./
RUN yarn install --non-interactive

COPY webpack.config.js ./
COPY assets ./assets/

RUN mkdir -p public/build \
  && ./node_modules/.bin/encore production

# https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
#=======================================================================
# "php" stage
FROM php:${PHP_VERSION}-fpm-alpine AS salt_core_php

# persistent / runtime deps
RUN apk add --no-cache \
		acl \
		bash \
		fcgi \
		file \
		gettext \
		git \
		gnu-libiconv \
	;

# install gnu-libiconv and set LD_PRELOAD env to make iconv work fully on Alpine image.
# see https://github.com/docker-library/php/issues/240#issuecomment-763112749
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so


ARG DOCKERIZE_VERSION=v0.6.1
RUN curl -LsS https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
	  | tar -C /usr/local/bin -xzvf -

ARG APCU_VERSION=5.1.21

RUN set -eux; \
	apk add --no-cache --virtual .build-deps \
		$PHPIZE_DEPS \
		bzip2-dev \
		icu-dev \
		libpng-dev \
		libzip-dev \
		mysql-dev \
		zlib-dev \
	; \
	\
	docker-php-ext-configure zip; \
	docker-php-ext-install -j$(nproc) \
		bcmath \
		bz2 \
		gd \
		intl \
		mysqli \
		opcache \
		pcntl \
		pdo_mysql \
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
	apk add --no-cache --virtual .api-phpexts-rundeps $runDeps; \
	\
	apk del .build-deps

COPY docker/php/docker-healthcheck.sh /usr/local/bin/docker-healthcheck
RUN chmod +x /usr/local/bin/docker-healthcheck
HEALTHCHECK --interval=10s --timeout=3s --retries=3 --start-period=30s CMD ["docker-healthcheck"]

#COPY docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
#RUN chmod +x /usr/local/bin/docker-entrypoint
#ENTRYPOINT ["docker-entrypoint"]

# Install symfony-cli
#ARG SYMFONY_CLI_VERSION=4.21.6
#RUN curl -LsS https://github.com/symfony/cli/releases/download/v$SYMFONY_CLI_VERSION/symfony_linux_amd64  -o /usr/local/bin/symfony \
#    && chmod a+x /usr/local/bin/symfony \
#	&& symfony self-update -y

# Install and configure composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER=1 \
    PATH="${PATH}:/root/.composer/vendor/bin" \
    COMPOSER_MEMORY_LIMIT=-1
#    PATH=/composer/vendor/bin:$PATH
#    COMPOSER_HOME=/composer

RUN ln -s $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini
COPY docker/php/conf.d/*.ini $PHP_INI_DIR/conf.d/
COPY docker/php/php-fpm.d/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf

#RUN composer global require \
#        maglnet/composer-require-checker \
#        insolita/unused-scanner \
#            --prefer-dist --no-progress --no-suggest --classmap-authoritative \
#        && composer clear-cache \
#	&& chmod -R a+w ${COMPOSER_HOME}

WORKDIR /srv/core

#=======================================================================
# "php" stage
FROM salt_core_php AS salt_core_vendors

# prevent the reinstallation of vendors at every changes in the source code
COPY composer.json composer.lock symfony.lock ./
RUN set -eux; \
	composer install --no-interaction --prefer-dist --no-autoloader --no-scripts --no-progress; \
	composer clear-cache

#=======================================================================
# Squash the COPY layers into 1 layer
FROM salt_core_php AS salt_code_layer

# build for production
ARG APP_ENV=prod

# copy only specifically what we need
COPY .env \
     composer.json composer.lock symfony.lock \
     package.json webpack.config.js yarn.lock \
     codeception.dist.yml \
	 ./
COPY bin/ bin/
COPY config/ config/
COPY migrations/ migrations/
COPY public/ public/
COPY src/ src/
COPY templates/ templates/
COPY translations/ translations/
COPY tests/ tests/

COPY --from=salt_core_vendors /srv/core/vendor/ ./vendor/
# hack to avoid "Service 'php' failed to build : failed to export image: failed to create image: failed to get layer sha256:38c02bf8b1bff96084338f7e6835b713185e091467e11f08001d41375f078e0e: layer does not exist"
# as mentioned in https://github.com/moby/moby/issues/37965#issuecomment-426853382
RUN true
COPY --from=salt_core_js_build /srv/core/public/ ./public/

RUN set -eux; \
	mkdir -p var/cache var/log; \
	chmod 777 var/cache var/log; \
	mkdir -p public/attachments; \
	chmod 777 public/attachments; \
	chmod 777 tests/_output tests/_data tests/_support/_generated; \
	chmod +x bin/console-real; sync; \
	composer dump-autoload --no-interaction --classmap-authoritative; \
	composer dump-env prod; \
	composer run-script post-install-cmd

ARG VERSION=3.2.0
ARG BUILD_NUMBER=x
ARG BUILD_DATE=0
ARG COMMIT=unknown

RUN echo ${VERSION}.${BUILD_NUMBER} > public/version.txt ; \
    echo ${VERSION}.${BUILD_NUMBER}+${BUILD_DATE}.${COMMIT} > public/revision.txt

#=======================================================================
FROM salt_core_php AS salt_core_app

ENV SYMFONY_PHPUNIT_VERSION=9

ARG VERSION=3.2.0
ARG BUILD_NUMBER=x
ARG BUILD_DATE=0
ARG COMMIT=unknown

LABEL org.opencontainers.title="OpenSALT PHP Application" \
      org.opencontainers.source="https://github.com/opensalt/opensalt" \
      org.opencontainers.version=${VERSION}.${BUILD_NUMBER}+${BUILD_DATE}.${COMMIT}

COPY --from=salt_code_layer /srv/core/ ./

VOLUME /srv/core/var
VOLUME /srv/core/public/attachments

USER www-data

#=======================================================================
FROM salt_core_app as salt_core_dev

ARG XDEBUG_VERSION=3.1.4

USER root
RUN set -eux; \
	apk add --no-cache --virtual .build-deps $PHPIZE_DEPS; \
	pecl install xdebug-$XDEBUG_VERSION; \
	docker-php-ext-enable xdebug; \
	apk del .build-deps

USER www-data

#=======================================================================
FROM caddy:${CADDY_VERSION}-builder-alpine AS salt_core_caddy_builder

# install Mercure and Vulcain modules
ARG XCADDY_SKIP_CLEANUP=0
RUN xcaddy build \
    --with github.com/dunglas/mercure \
    --with github.com/dunglas/mercure/caddy \
    --with github.com/dunglas/vulcain \
    --with github.com/dunglas/vulcain/caddy

#=======================================================================
FROM caddy:${CADDY_VERSION} AS salt_core_caddy

RUN addgroup -g 1001 caddy; \
    adduser -u 1001 -G caddy -D -s /sbin/nologin \
        -g "Default Application User" caddy

COPY --from=salt_core_caddy_builder /usr/bin/caddy /usr/bin/caddy
COPY docker/caddy/Caddyfile /etc/caddy/Caddyfile
COPY docker/caddy/docker-healthcheck /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-healthcheck
HEALTHCHECK --interval=10s --timeout=3s --retries=3 --start-period=30s CMD ["docker-healthcheck"]

RUN mkdir -p /data/caddy /config/caddy ;\
    chown -R caddy:caddy /data/caddy /config/caddy

ARG VERSION=3.2.0
ARG BUILD_NUMBER=x
ARG BUILD_DATE=0
ARG COMMIT=unknown

LABEL org.opencontainers.title="OpenSALT Web Server" \
      org.opencontainers.source="https://github.com/opensalt/opensalt" \
      org.opencontainers.version=${VERSION}.${BUILD_NUMBER}+${BUILD_DATE}.${COMMIT}

WORKDIR /srv/core
VOLUME /data/caddy
VOLUME /config/caddy

COPY --from=salt_core_app /srv/core/public public/

USER caddy
