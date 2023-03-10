ARG PHP_BUILD_VERSION
ARG PHP_TEST_VERSION
ARG PHP_DEPS_VERSION

# Composer on correct PHP version
FROM php:${PHP_DEPS_VERSION}-cli as composer

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN echo 'memory_limit = 128M' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini;

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=/usr/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"

RUN apt-get update
RUN apt-get install --no-install-recommends -y \
    zip \
    unzip \
    curl \
    git \

    zlib1g-dev \
    libicu-dev && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-install intl json && \
    docker-php-ext-enable intl json

# Composer on correct PHP version
FROM php:${PHP_BUILD_VERSION}-cli as build

ARG BUILD_ROOT_PATH

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN echo 'memory_limit = 256M' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini;

RUN apt-get update
RUN apt-get install --no-install-recommends -y gnupg apt-transport-https ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update
RUN apt-get install --no-install-recommends -y \
    zip \
    unzip \
    curl \
    git \
    yarn \

    zlib1g-dev \
    libicu-dev \
    g++ \

    wget && rm -rf /var/lib/apt/lists/*;

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=/usr/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"

RUN docker-php-ext-install intl json && \
    docker-php-ext-enable intl json

# Install Node
RUN curl -f -sL https://deb.nodesource.com/setup_15.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Install Phive
RUN wget -O phive.phar "https://phar.io/releases/phive.phar"
RUN wget -O phive.phar.asc "https://phar.io/releases/phive.phar.asc"
RUN gpg --batch --keyserver hkps.ha.pool.sks-keyservers.net --recv-keys 0x9D8A98B29B2D5D79
RUN gpg --batch --verify phive.phar.asc phive.phar && rm phive.phar.asc
RUN rm phive.phar.asc && \
    chmod +x phive.phar && \
    mv phive.phar /usr/local/bin/phive

WORKDIR ${BUILD_ROOT_PATH}
COPY . ./


FROM php:${PHP_TEST_VERSION}-cli as test

ARG BUILD_ROOT_PATH

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN apt-get update
RUN apt-get install --no-install-recommends -y \

    zlib1g-dev \
    libicu-dev \
    g++ && rm -rf /var/lib/apt/lists/*;
RUN pecl install xdebug-2.5.5
RUN docker-php-ext-install pcntl posix intl json

WORKDIR ${BUILD_ROOT_PATH}
COPY --from=build ${BUILD_ROOT_PATH} ${BUILD_ROOT_PATH}


# Install PHP dev dependencies
FROM build as vendor-dev

ARG BUILD_ROOT_PATH

WORKDIR ${BUILD_ROOT_PATH}
RUN composer install


# WordPress for development
FROM wordpress:5-php${PHP_TEST_VERSION}-apache as dev

ARG PROJECT_MOUNT_PATH
ARG BUILD_ROOT_PATH
ARG DOCROOT_PATH
ARG WP_DOMAIN

COPY docker/wp-entrypoint.sh /usr/local/bin
COPY docker/wait-for-it.sh /usr/local/bin

RUN chmod +x /usr/local/bin/wp-entrypoint.sh /usr/local/bin/wait-for-it.sh

RUN curl -f -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp
RUN sed -i "s|#ServerName www.example.com|ServerName ${WP_DOMAIN}|" /etc/apache2/sites-available/*.conf
RUN sed -i "s|#ServerName www.example.com|ServerName ${WP_DOMAIN}|" /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf


RUN apt-get update
RUN apt-get install --no-install-recommends -y \
    zip \
    unzip \
    curl \

    zlib1g-dev \
    libicu-dev \
    g++ && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-install pcntl posix intl json

RUN apt-get remove -y \
    # These are for extensions
    zlib1g-dev \
    libicu-dev \
    g++

WORKDIR ${DOCROOT_PATH}
COPY --from=vendor-dev ${BUILD_ROOT_PATH} ${PROJECT_MOUNT_PATH}

ENTRYPOINT ["wp-entrypoint.sh"]
CMD ["apache2-foreground"]
