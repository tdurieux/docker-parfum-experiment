FROM php:7.4.8

RUN  sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && apt-get clean

RUN apt-get update && \
    apt-get install --no-install-recommends -y openssl libssl-dev && \
    pecl channel-update pecl.php.net && \
    apt-get install --no-install-recommends -y git && \
    curl -f -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/bin/composer && \
    composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ && rm -rf /var/lib/apt/lists/*;

USER root

    # Install the zip mysqli pdo_mysql extension
RUN apt-get install --no-install-recommends libzip-dev zip unzip -y && \
    docker-php-ext-configure zip && \
    docker-php-ext-install zip mysqli pdo_mysql sockets && rm -rf /var/lib/apt/lists/*;

    # Install Php Redis Extension
RUN curl -f 'https://pecl.php.net/get/redis-5.1.1.tgz' -o /tmp/redis-5.1.1.tgz \
    && cd /tmp \
    && pecl install redis-5.1.1.tgz \
    && rm -rf /tmp/redis-5.1.1.tgz \
    && docker-php-ext-enable redis

    # Install Amqp extension
RUN apt-get -y --no-install-recommends install cmake && \
    curl -f -L -o /tmp/rabbitmq-c.tar.gz https://github.com/alanxz/rabbitmq-c/archive/master.tar.gz && \
    mkdir -p rabbitmq-c && \
    tar -C rabbitmq-c -zxvf /tmp/rabbitmq-c.tar.gz --strip 1 && \
    cd rabbitmq-c/ && \
    mkdir _build && cd _build/ && \
    cmake .. && \
    cmake --build . --target install && \
    pecl install amqp && \
    docker-php-ext-enable amqp && \
    # Install bcmath
    docker-php-ext-install bcmath && rm /tmp/rabbitmq-c.tar.gz && rm -rf /var/lib/apt/lists/*;

RUN cd /tmp \
    && curl -f -SL "https://github.com/swoole/swoole-src/archive/v4.5.2.tar.gz" -o swoole.tar.gz \
    && ls -alh \
    # php extension:swoole
    && cd /tmp \
    && mkdir -p swoole \
    && tar -xf swoole.tar.gz -C swoole --strip-components=1 \
    && ( cd swoole \
    && phpize \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-sockets --enable-mysqlnd --enable-openssl --enable-http2 \
    && make -s -j$(nproc) && make install) \

    && echo "extension=swoole.so" > /usr/local/etc/php/conf.d/50_swoole.ini \
    && echo "swoole.use_shortname = 'Off'" >> /usr/local/etc/php/conf.d/50_swoole.ini \
    # clear
    && php -v \
    && php -m \
    && php --ri swoole && rm swoole.tar.gz

USER root

    # Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /var/log/lastlog /var/log/faillog

ENTRYPOINT ["php", "/www/hyperf/bin/hyperf.php", "start"]

EXPOSE 9501
