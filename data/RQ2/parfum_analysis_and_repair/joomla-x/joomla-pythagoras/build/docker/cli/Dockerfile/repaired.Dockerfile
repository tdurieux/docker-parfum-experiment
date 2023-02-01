FROM php:7-cli

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        libpqxx-dev \
        ruby \
        ruby-dev \
        build-essential \
        sqlite3 \
        libsqlite3-dev && rm -rf /var/lib/apt/lists/*;

# Install Composer
RUN cd /usr/src \
    && curl -f -sS https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Install MailCatcher
RUN gem install mailcatcher --no-ri --no-rdoc

# Setup the Xdebug version to install
ENV XDEBUG_VERSION 2.5.1
ENV XDEBUG_SHA256 7fda9020fd5a2c549ae5a692fcabbb00f74e39dda81d53d25e622bdab4880ec2

# Install Xdebug
RUN set -x \
    && curl -f -SL "https://www.xdebug.org/files/xdebug-$XDEBUG_VERSION.tgz" -o xdebug.tgz \
    && echo $XDEBUG_SHA256 xdebug.tgz | sha256sum -c - \
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
COPY prepend.php /usr/local/lib/php/
COPY append.php /usr/local/lib/php/
COPY phpunit_coverage.php /usr/local/lib/php/
COPY runtests.sh /
RUN chmod +x /runtests.sh

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

ENTRYPOINT /runtests.sh
