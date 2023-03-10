FROM php:7.1-cli

MAINTAINER fucongcong

RUN apt-get update -yqq \
    && apt-get install --no-install-recommends -yqq wget \
    && apt-get install --no-install-recommends -yqq libpng-dev \
    && apt-get install --no-install-recommends -yqq libicu-dev \
    && apt-get install --no-install-recommends -yqq libmcrypt-dev \
    && apt-get install --no-install-recommends -yqq libpcre3-dev \
    && apt-get install --no-install-recommends -yqq libjpeg62-turbo-dev \
    && apt-get install --no-install-recommends -yqq libfreetype6-dev \
    && apt-get install --no-install-recommends -yqq build-essential chrpath libssl-dev libfontconfig1-dev libxft-dev \
    && apt-get install --no-install-recommends -yqq zip \
    && wget https://github.com/redis/hiredis/archive/v0.13.3.zip \
    && unzip v0.13.3.zip \
    && rm v0.13.3.zip \
    && cd hiredis-0.13.3 \
    && make && make install \
    && ldconfig \
    && cd .. \
    && rm -rf hiredis-0.13.3 \
    && wget https://github.com/swoole/swoole-src/archive/v1.10.1.zip \
    && unzip v1.10.1.zip \
    && rm v1.10.1.zip \
    && cd swoole-src-1.10.1 \
    && phpize \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-async-redis \
    && make \
    && make install \
    && cd .. \
    && rm -rf swoole-src-1.10.1 \
    && echo "extension=swoole.so" > /usr/local/etc/php/conf.d/docker-php-ext-swoole.ini \
    && wget https://pecl.php.net/get/redis-4.1.0.tgz \
    && tar xzf redis-4.1.0.tgz \
    && rm redis-4.1.0.tgz \
    && cd redis-4.1.0 \
    && phpize \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install \
    && cd .. \
    && rm -rf redis-4.1.0 \
    && echo "extension=redis.so" > /usr/local/etc/php/conf.d/docker-php-ext-redis.ini \
    && docker-php-ext-install gd \
    && docker-php-ext-install zip \
    && docker-php-ext-install intl \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install exif \
    && docker-php-ext-install gettext \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install sockets \
    && apt-get purge --auto-remove -y \
           wget \
    && apt-get purge --auto-remove -y \
           zip && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*
ADD . /GroupCo
WORKDIR /GroupCo
