FROM php:7-fpm-alpine
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk update && apk upgrade && \
	apk add autoconf g++ make libmemcached-dev cyrus-sasl-dev libxml2-dev 

RUN pecl install xdebug && docker-php-ext-enable xdebug

RUN mkdir /var/log/profiler

# 192.168.2.226为本机IP，9001为vscdoe监听的端口，用于容器发现。
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini && \
    printf "[xdebug] \n\
xdebug.remote_enable = 1 \n\
xdebug.remote_host=192.168.2.226 \n\
xdebug.remote_port=9001 \n\
xdebug.remote_autostart = 1 \n\
xdebug.profiler_output_dir = /tmp/profiler/" >> /usr/local/etc/php/php.ini