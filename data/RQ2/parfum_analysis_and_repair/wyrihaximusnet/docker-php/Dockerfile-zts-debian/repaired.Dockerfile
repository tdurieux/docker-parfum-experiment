FROM php:7.4-zts-buster AS base

# Build-time metadata as defined at http://label-schema.org
LABEL org.label-schema.name="wyrihaximusnet/php" \
      org.label-schema.description="Opinionated ReactPHP optimised PHP Docker images" \
      org.label-schema.url="https://github.com/wyrihaximusnet/docker-php" \
      org.label-schema.vcs-url="https://github.com/wyrihaximusnet/docker-php" \
      org.label-schema.vendor="WyriHaximus.net" \
      org.label-schema.schema-version="1.0"

RUN apt-get update \
    && yes | apt-get upgrade \
    && set -x \
    && addgroup --gid 1000 app \
    && adduser --uid 1000 --gid 1000 --disabled-password app --home /opt/app \
    && touch /.you-are-in-a-wyrihaximus.net-php-docker-image

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

FROM base AS base-build
RUN yes | apt-get install -y --no-install-recommends $PHPIZE_DEPS git libuv1-dev && rm -rf /var/lib/apt/lists/*;

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

# Patch CVE-2018-14618 (curl), CVE-2018-16842 (libxml2), CVE-2019-1543 (openssl)
RUN yes | apt-get upgrade curl libxml2 openssl

# Install docker help scripts
COPY src/php/utils/docker/debian/ /usr/local/bin/

COPY src/php/conf/ /usr/local/etc/php/conf.d/
COPY src/php/cli/conf/*.ini /usr/local/etc/php/conf.d/

RUN EXTENSION_DIR=`php-config --extension-dir 2>/dev/null` && \
	mv /*.so "$EXTENSION_DIR/" && \
    yes | apt-get install -y --no-install-recommends \
        libgmp-dev \
        zlib1g-dev \
        libpq-dev \
        libzip-dev \
        libuv1-dev \
        libicu-dev \
        make \
        git \
        openssh-client \
        bash \
        coreutils \
        procps \
        git \
        wget \
        gdb \
        $PHPIZE_DEPS \
    && docker-php-ext-install -j$(nproc) pcntl pgsql pdo pdo_pgsql bcmath zip gmp iconv intl \
    && pecl install parallel || ( cd /tmp && ( yes | apt-get install -y --no-install-recommends $PHPIZE_DEPS git) && git clone https://github.com/WyriHaximus-labs/parallel && cd parallel && git fetch && git checkout php-8.1-part-2 && git pull && phpize && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make install && cd) \
    && docker-php-ext-enable parallel \
    && if [ $(php -v | grep "PHP 8." | wc -l) != 0 ] ; then true ; else pecl install eio; fi \
    && if [ $(php -v | grep "PHP 8." | wc -l) != 0 ] ; then true ; else docker-php-ext-enable eio; fi \
    && docker-php-ext-enable uv \
    && wget -q -O - https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh > /bin/wait-for \
    && chmod +x /bin/wait-for \
    && yes | apt-get purge wget $PHPIZE_DEPS \
    && yes | apt-get install -y --no-install-recommends make \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/* && rm -rf /var/lib/apt/lists/*;

STOPSIGNAL SIGTERM

ENTRYPOINT ["docker-php-entrypoint"]

## ZTS-DEV STAGE ##
FROM zts-slim-root AS zts-root

# Install ext-gd and ext-vips
COPY src/php/utils/docker/debian/install-gd-and-vips /usr/local/bin/install-gd-and-vips
RUN if [ $(php -v | grep "alpha\|ALPHA\|beta\|BETA\|rc\|RC" | wc -l) != 0 ] ; then true ; else install-gd-and-vips; fi \
     && rm -rf /usr/local/bin/install-gd-and-vips

## ZTS-DEV STAGE ##
FROM zts-slim-root AS zts-slim-dev-root

RUN touch /.you-are-in-a-wyrihaximus.net-php-docker-image-dev

# Install docker help scripts
COPY src/php/utils/docker/debian/dev-mode /usr/local/bin/dev-mode
COPY src/php/utils/docker/debian/docker-php-dev-mode /usr/local/bin/docker-php-dev-mode
RUN if [ $(php -v | grep "alpha\|ALPHA\|beta\|BETA\|rc\|RC" | wc -l) != 0 ] ; then true ; else dev-mode; fi \
    && rm -rf /usr/local/bin/dev-mode \
    && rm -rf /usr/local/bin/docker-php-dev-mode \
    && yes | apt-get install -y --no-install-recommends make && rm -rf /var/lib/apt/lists/*;

# Install composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer


ENTRYPOINT ["docker-php-entrypoint"]

## ZTS-DEV STAGE ##
FROM zts-root AS zts-dev-root

RUN touch /.you-are-in-a-wyrihaximus.net-php-docker-image-dev

# Install docker help scripts
COPY src/php/utils/docker/debian/dev-mode /usr/local/bin/dev-mode
COPY src/php/utils/docker/debian/docker-php-dev-mode /usr/local/bin/docker-php-dev-mode
RUN if [ $(php -v | grep "alpha\|ALPHA\|beta\|BETA\|rc\|RC" | wc -l) != 0 ] ; then true ; else dev-mode; fi \
    && rm -rf /usr/local/bin/dev-mode \
    && rm -rf /usr/local/bin/docker-php-dev-mode \
    && yes | apt-get install -y --no-install-recommends make && rm -rf /var/lib/apt/lists/*;

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
