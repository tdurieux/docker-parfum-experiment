FROM php:7.2-fpm

RUN apt-get update

RUN set -ex && \
    apt-get install --no-install-recommends vim -y && \
    apt-get install --no-install-recommends openssl -y && \
    apt-get install --no-install-recommends libssl-dev -y && \
    apt-get install --no-install-recommends wget -y && \
    apt-get install --no-install-recommends libpq-dev -y && rm -rf /var/lib/apt/lists/*;

RUN cd /tmp && wget https://pecl.php.net/get/swoole-4.2.9.tgz && \
    tar zxvf swoole-4.2.9.tgz && \
    cd swoole-4.2.9  && \
    phpize && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-openssl && \
    make && make install && rm swoole-4.2.9.tgz

RUN touch /usr/local/etc/php/conf.d/swoole.ini && \
    echo 'extension=swoole.so' > /usr/local/etc/php/conf.d/swoole.ini

RUN docker-php-ext-install pdo_pgsql

WORKDIR /var/www/html/ws-chat

EXPOSE 8101