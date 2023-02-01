FROM php:7.3-apache

# PHP extensions
ENV APCU_VERSION 5.1.11
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN buildDeps=" \
        libicu-dev \
        zlib1g-dev \
        libzip-dev \
        bzip2 \
        wget\
    " \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        $buildDeps \
        libicu57 \
        zlib1g \
        libzip4 \
        git \
        fontconfig \
        unzip \
    && wget https://raw.githubusercontent.com/n7consulting/phantomjs-build/master/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
    && tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2 \
    && mv phantomjs-2.1.1-linux-x86_64 /usr/local/bin \
    && ln -sf /usr/local/bin/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin \
    && phantomjs --version \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install \
        intl \
        mbstring \
        pdo_mysql \
        zip \
    && apt-get purge -y --auto-remove $buildDeps \
    && pecl install \
        apcu-$APCU_VERSION \
    && docker-php-ext-enable --ini-name 05-opcache.ini \
        opcache \
    && docker-php-ext-enable --ini-name 20-apcu.ini \
        apcu

# Apache config
RUN a2enmod rewrite headers
COPY docker/web/vhost.conf /etc/apache2/sites-available/000-default.conf
COPY docker/web/php.ini /usr/local/etc/php/php.ini
COPY docker/web/composer.sh /usr/bin/composer.sh

# Install composer
RUN /usr/bin/composer.sh \
    && mv composer.phar /usr/bin/composer \
    && composer global require "hirak/prestissimo:^0.3" --prefer-dist --no-progress --no-suggest --classmap-authoritative \
    && composer clear-cache

# Add dependencies (before app to make a better cache usage)
WORKDIR /app
COPY ./composer.json ./composer.lock /app/
RUN mkdir -p var/cache var/logs var/sessions public/tmp \
    # Install dependencies
    && composer install --prefer-dist --no-dev --no-autoloader --no-scripts --no-progress --no-suggest \
    && composer clear-cache

# Add application
COPY ./ /app
RUN composer dump-autoload --classmap-authoritative --no-dev \
    && composer run-script --no-dev post-install-cmd \
    # Fixes permissions issues in non-dev mode
    && chown -R www-data . var/cache var/logs var/sessions public/tmp

CMD ["/app/docker/web/start.sh"]
