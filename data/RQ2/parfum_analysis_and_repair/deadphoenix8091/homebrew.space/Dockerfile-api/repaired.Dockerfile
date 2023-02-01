FROM php:7.4-cli

RUN apt-get update && apt-get install --no-install-recommends vim -y && \
    apt-get install --no-install-recommends openssl -y && \
    apt-get install --no-install-recommends libssl-dev -y && \
    apt-get install --no-install-recommends wget -y && \
    apt-get install --no-install-recommends git -y && \
    apt-get install --no-install-recommends procps -y && \
    apt-get install --no-install-recommends htop -y && \
    apt-get install --no-install-recommends npm -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y \
    libzip-dev \
    zip \
  && docker-php-ext-install zip && rm -rf /var/lib/apt/lists/*;

RUN cd /tmp && git clone https://github.com/swoole/swoole-src.git && \
    cd swoole-src && \
    git checkout v4.5.4 && \
    phpize && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-openssl && \
    make && make install

RUN touch /usr/local/etc/php/conf.d/swoole.ini && \
    echo 'extension=swoole.so' > /usr/local/etc/php/conf.d/swoole.ini

RUN docker-php-ext-install pdo_mysql

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64
RUN chmod +x /usr/local/bin/dumb-init

RUN apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y libmagickwand-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN printf "\n" | pecl install imagick
RUN docker-php-ext-enable imagick

ADD ./api /code
WORKDIR /code

RUN cd /code && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    php composer.phar install

ENTRYPOINT ["/usr/local/bin/dumb-init", "--", "php", "-d", "memory_limit=4G", "server.php"]