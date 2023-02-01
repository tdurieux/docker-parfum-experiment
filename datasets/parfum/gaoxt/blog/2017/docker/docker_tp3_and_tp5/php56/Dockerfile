FROM php:5.6.31-fpm-alpine

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apk update && apk upgrade && \
	apk add autoconf g++ make libmemcached-dev cyrus-sasl-dev libxml2-dev 

RUN docker-php-ext-install pdo_mysql mysql mysqli xml bcmath

RUN pecl install memcached-2.2.0 && docker-php-ext-enable memcached
RUN pecl install xdebug-2.5.5 && docker-php-ext-enable xdebug