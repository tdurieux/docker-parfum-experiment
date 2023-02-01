FROM php:7-fpm-alpine
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk update && apk upgrade && \
	apk add --no-cache autoconf g++ make libmemcached-dev cyrus-sasl-dev libxml2-dev
RUN docker-php-ext-install pdo_mysql mysqli xml