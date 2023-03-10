FROM php:7.4-zts-alpine3.11 AS base

# Build-time metadata as defined at http://label-schema.org
LABEL org.label-schema.name="wyrihaximusnet/php" \
      org.label-schema.description="Opinionated ReactPHP optimised PHP Docker images" \
      org.label-schema.url="https://github.com/wyrihaximusnet/docker-php" \
      org.label-schema.vcs-url="https://github.com/wyrihaximusnet/docker-php" \
      org.label-schema.vendor="WyriHaximus.net" \
      org.label-schema.schema-version="1.0"

RUN apk update \
    && apk upgrade \
    && set -x \
    && addgroup -g 1000 app \
    && adduser -u 1000 -D -G app app --home /opt/app \
    && touch /.you-are-in-a-wyrihaximus.net-php-docker-image

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

FROM base AS base-build
RUN apk add --no-cache $PHPIZE_DEPS git libuv-dev

FROM base-build AS build-uv
RUN git clone https://github.com/amphp/ext-uv uv
WORKDIR /uv
RUN git fetch \
    && git pull \
    && phpize \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make install \
    && EXTENSION_DIR=`php-config --extension-dir 2>/dev/null` \
    && cp "$EXTENSION_DIR/uv.so" /uv.so \
    && sha256sum /uv.so

FROM base AS zts-slim-root

COPY --from=build-uv /uv.so /uv.so

# Install docker help scripts
COPY src/php/utils/docker/alpine/ /usr/local/bin/

COPY src/php/conf/ /usr/local/etc/php/conf.d/
COPY src/php/cli/conf/*.ini /usr/local/etc/php/conf.d/

RUN EXTENSION_DIR=`php-config --extension-dir 2>/dev/null` && \
	mv /*.so "$EXTENSION_DIR/" && \
	apk add --no-cache \
        libuv-dev \
        icu-dev \
        make \
        git \
        openssh-client \
        bash \
        coreutils \
        procps \
        git \
        $PHPIZE_DEPS \
    ## Install PECL
    && wget -q pear.php.net/go-pear.phar && php go-pear.phar \
    && install-php-extensions pcntl pgsql pdo pdo_pgsql bcmath zip gmp iconv opcache intl \
    && pecl install parallel || ( cd /tmp && apk add --no-cache $PHPIZE_DEPS git && git clone https://github.com/WyriHaximus-labs/parallel && cd parallel && git fetch && git checkout php-8.1-part-2 && git pull && phpize && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make install && cd) \
    && docker-php-ext-enable parallel \
    && if [ $(php -v | grep "PHP 8." | wc -l) != 0 ] ; then true ; else pecl install eio; fi \
    && if [ $(php -v | grep "PHP 8." | wc -l) != 0 ] ; then true ; else docker-php-ext-enable eio; fi \
    && docker-php-ext-enable uv \
    && apk del $PHPIZE_DEPS \
    && wget -q -O - https://raw.githubusercontent.com/eficode/wait-for/master/wait-for > /bin/wait-for \
    && chmod +x /bin/wait-for \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*

STOPSIGNAL SIGTERM

ENTRYPOINT ["docker-php-entrypoint"]

## ZTS-DEV STAGE ##
FROM zts-slim-root AS zts-root

# Install ext-gd and ext-vips
COPY src/php/utils/docker/alpine/install-gd-and-vips /usr/local/bin/install-gd-and-vips
RUN if [ $(php -v | grep "alpha\|ALPHA\|beta\|BETA\|rc\|RC" | wc -l) != 0 ] ; then true ; else install-gd-and-vips; fi \
     && rm -rf /usr/local/bin/install-gd-and-vips

## ZTS-DEV STAGE ##
FROM zts-slim-root AS zts-slim-dev-root

RUN touch /.you-are-in-a-wyrihaximus.net-php-docker-image-dev

# Install docker help scripts
COPY src/php/utils/docker/alpine/dev-mode /usr/local/bin/dev-mode
RUN if [ $(php -v | grep "alpha\|ALPHA\|beta\|BETA\|rc\|RC" | wc -l) != 0 ] ; then true ; else dev-mode; fi && rm -rf /usr/local/bin/dev-mode

# Install composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer


ENTRYPOINT ["docker-php-entrypoint"]

## ZTS-DEV STAGE ##
FROM zts-root AS zts-dev-root

RUN touch /.you-are-in-a-wyrihaximus.net-php-docker-image-dev

# Install docker help scripts
COPY src/php/utils/docker/alpine/dev-mode /usr/local/bin/dev-mode
RUN if [ $(php -v | grep "alpha\|ALPHA\|beta\|BETA\|rc\|RC" | wc -l) != 0 ] ; then true ; else dev-mode; fi && rm -rf /usr/local/bin/dev-mode

# Install composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer


ENTRYPOINT ["docker-php-entrypoint"]

## ZTS-DEV stage ##
FROM zts-slim-dev-root AS zts-slim-dev
USER app

FROM zts-dev-root AS zts-dev
USER app

## ZTS stage ##
FROM zts-slim-root AS zts-slim
USER app

FROM zts-root AS zts
USER app
