FROM php:7.2-apache

LABEL maintainer="Jakub Bouček <pan@jakubboucek.cz>"
LABEL desc="NOTE: Unmaintained version, don't use it with serious deployment!"
LABEL org.label-schema.name="PHP 7.2 (Apache module)"
LABEL org.label-schema.description="NOTE: Unmaintained version, don't use it with serious deployment!"
LABEL org.label-schema.vcs-url="https://github.com/jakubboucek/docker-lamp-devstack"

# Workdir during installation
WORKDIR /tmp

# Prevent interactive block
ARG DEBIAN_FRONTEND=noninteractive

# OS binaries install && update critical binaries
RUN set -eux; \
    apt-get update; \
    apt-get install --no-install-recommends -y \
        ca-certificates \
        git \
        libbz2-dev \
        libc-client-dev \
        libfreetype6-dev \
        libgmp-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libkrb5-dev \
        libpng-dev \
        libsodium-dev \
        libwebp-dev \
        libxslt-dev \
        libzip-dev \
        nano \
        openssl \
        tzdata \
        unzip \
        zip; \
    docker-php-ext-configure \
        gd --with-freetype-dir --with-jpeg-dir=/usr/include/ --with-webp-dir=/usr/include/; \
    docker-php-ext-configure \
        imap --with-kerberos --with-imap-ssl; \
    docker-php-ext-install -j$(nproc) \
        bcmath \
        bz2 \
        calendar \
        exif \
        gd \
        gettext \
        gmp \
        imap \
        intl \
        mysqli \
        opcache \
        pcntl \
        pdo_mysql \
        soap \
        sockets \
        sodium \
        sysvmsg \
        sysvsem \
        sysvshm \
        xsl \
        zip; \
    a2enmod \
        expires \
        headers \
        rewrite; \
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /var/lib/log/* /tmp/* /var/tmp/*;

# Configure Apache & PHP
ENV PHP_MAX_EXECUTION_TIME 30
ENV PHP_MEMORY_LIMIT 2G
ENV PHP_SESSION_SAVE_PATH ""
COPY core.ini /usr/local/etc/php/conf.d/core.ini

# Configure OPcache
ENV PHP_OPCACHE_ENABLE 1
ENV PHP_OPCACHE_ENABLE_CLI 0
ENV PHP_OPCACHE_MEMORY_CONSUPTION 128
ENV PHP_OPCACHE_REVALIDATE_FREQ 2
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS 1
COPY opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Move Apache Document root to sub-directory `www` (PHP frameworks convention)
ENV APACHE_DOCUMENT_ROOT /var/www/html/www

# Setup Devstack (install Composer, setup DocumentRoot)
RUN set -eux; \
    curl -f -sS https://getcomposer.org/installer -o /tmp/composer-setup.php; \
    php /tmp/composer-setup.php --1 --install-dir=/usr/local/bin --filename=composer; \
    COMPOSER_BIN_DIR=$(composer global config bin-dir --absolute) 2>/dev/null; \
    echo "export PATH=${COMPOSER_BIN_DIR}:\${PATH}" >> ~/.bashrc; \
    sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf; \
    rm -rf /tmp/*;

# Workdir after installation
WORKDIR /var/www/html
