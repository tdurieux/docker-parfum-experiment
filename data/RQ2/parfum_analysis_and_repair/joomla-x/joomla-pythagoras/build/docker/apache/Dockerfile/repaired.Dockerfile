FROM php:7-apache

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        libpqxx-dev \
        ruby \
        ruby-dev \
        build-essential \
        sqlite3 \
        libsqlite3-dev && rm -rf /var/lib/apt/lists/*;

# Install MailCatcher
RUN gem install mailcatcher --no-ri --no-rdoc

# Setup the Xdebug version to install
ENV XDEBUG_VERSION 2.4.1
ENV XDEBUG_SHA1 52b5cede5dcb815de469d671bfdc626aec8adee3

# Install Xdebug
RUN set -x \
    && curl -f -SL "https://www.xdebug.org/files/xdebug-$XDEBUG_VERSION.tgz" -o xdebug.tgz \
    && echo $XDEBUG_SHA1 xdebug.tgz | sha1sum -c - \
    && mkdir -p /usr/src/xdebug \
    && tar -xf xdebug.tgz -C /usr/src/xdebug --strip-components=1 \
    && rm xdebug.* \
    && cd /usr/src/xdebug \
    && phpize \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make -j"$(nproc)" \
    && make install \
    && make clean && rm -rf /usr/src/xdebug

COPY php.ini /usr/local/etc/php/
COPY conf.d/* /usr/local/etc/php/conf.d/

RUN docker-php-ext-install mysqli \
    && docker-php-ext-install pgsql \
    && docker-php-ext-install pdo_mysql pdo_pgsql

# Cleanup package manager
RUN apt-get remove --purge -y \
        build-essential \
        ruby-dev \
        libsqlite3-dev \
    && apt-get autoclean \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
