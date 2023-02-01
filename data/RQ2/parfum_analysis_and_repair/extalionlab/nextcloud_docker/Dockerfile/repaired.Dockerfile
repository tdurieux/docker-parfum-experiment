# the different stages of this Dockerfile are meant to be built into separate images
# https://docs.docker.com/develop/develop-images/multistage-build/#stop-at-a-specific-build-stage
# https://docs.docker.com/compose/compose-file/#target


# https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG NEXTCLOUD_VERSION=24


# "nextcloud" stage
FROM nextcloud:${NEXTCLOUD_VERSION}-fpm AS nextcloud


RUN set -eux; \
    \
    ln -sr $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini
COPY docker/nextcloud/conf.d/nextcloud.ini $PHP_INI_DIR/conf.d/zzz-nextcloud.ini
COPY docker/nextcloud/php-fpm.d/nextcloud.conf $PHP_INI_DIR/../php-fpm.d/zzz-nextcloud.conf


RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ffmpeg \
        libmagickcore-6.q16-6-extra \
        procps \
        smbclient \
        supervisor \
    ; \
    rm -rf /var/lib/apt/lists/*

RUN set -ex; \
    \
    savedAptMark="$(apt-mark showmanual)"; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libbz2-dev \
        libc-client-dev \
        libkrb5-dev \
        libsmbclient-dev \
    ; \
    \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl; \
    docker-php-ext-install \
        bz2 \
        imap \
    ; \
    pecl install \
        smbclient \
    ; \
    \
    docker-php-ext-enable smbclient; \
    \
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies