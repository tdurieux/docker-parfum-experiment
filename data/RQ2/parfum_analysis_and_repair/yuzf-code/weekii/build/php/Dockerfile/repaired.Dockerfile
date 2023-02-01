FROM php:latest

MAINTAINER Roki "619565627@qq.com"


RUN apt-get update && \
    apt-get install --no-install-recommends libzip-dev -y && \
    pecl install -o -f zip && \
    docker-php-ext-enable zip && \
    pecl install -o -f redis && \
    docker-php-ext-enable redis && \
    pecl install -o -f swoole && \
    docker-php-ext-enable swoole && \
    docker-php-ext-install pdo_mysql && rm -rf /var/lib/apt/lists/*;

WORKDIR /data/website/blog/Bin

CMD php server.php
