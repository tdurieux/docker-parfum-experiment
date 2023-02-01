FROM php:7.0-fpm

MAINTAINER Larry Eitel <larry@eitel.com>

ADD ./laravel.ini /usr/local/etc/php/conf.d
ADD ./xdebug.ini /usr/local/etc/php/conf.d
ADD ./laravel.pool.conf /usr/local/etc/php-fpm.d/

RUN apt-get update && apt-get install -y \
    libpq-dev \
    libmemcached-dev \
    php-pear \
    libpng12-dev \
    libfreetype6-dev \
    ssh \
    telnet \
    git \
    curl \
    less \
    vim \
    nano \
    --no-install-recommends \
    && rm -r /var/lib/apt/lists/*

# configure gd library
RUN docker-php-ext-configure gd \
    --enable-gd-native-ttf \
    --with-freetype-dir=/usr/include/freetype2

# Install extensions using the helper script provided by the base image
RUN docker-php-ext-install \
    pdo_mysql \
    gd

# Install Memcached for php 7
RUN curl -L -o /tmp/memcached.tar.gz "https://github.com/php-memcached-dev/php-memcached/archive/php7.tar.gz" \
    && mkdir -p /usr/src/php/ext/memcached \
    && tar -C /usr/src/php/ext/memcached -zxvf /tmp/memcached.tar.gz --strip 1 \
    && docker-php-ext-configure memcached \
    && docker-php-ext-install memcached \
    && rm /tmp/memcached.tar.gz


# Install xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug


# Install mongodb driver
# RUN pecl install mongodb


RUN rm -f /etc/service/sshd/down

## Created keys for vm use
RUN mkdir -p /root/.ssh
ADD ./id_rsa_vm /root/.ssh
ADD ./id_rsa_vm.pub /root/.ssh
RUN ls /root/.ssh
RUN touch /root/.ssh/authorized_keys
RUN cat /root/.ssh/id_rsa_vm.pub >> /root/.ssh/authorized_keys

RUN usermod -u 1000 www-data

# WORKDIR /var/www/laravel
WORKDIR /var/www/cpo

CMD ["php-fpm"]
# CMD ["ssh"]

EXPOSE 9000
