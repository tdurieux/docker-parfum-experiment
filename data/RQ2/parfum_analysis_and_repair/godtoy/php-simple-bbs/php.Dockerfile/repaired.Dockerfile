#可以按照需求切换版本
FROM php:5.6-fpm
MAINTAINER Godtoy <zhaojunlike@gmail.com>
#update apt source mirrors
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    && apt-get update && apt-get install --no-install-recommends -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt pdo_mysql mysqli mysql mbstring opcache \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install redis-3.1.0 \
    && docker-php-ext-enable redis \

#Flag:最后记得清理apt产生的垃圾，减少空间占用  rm -rf /....
COPY ./dockerfiles/php/php-prod.ini /usr/local/etc/php/php.ini && rm -rf /var/lib/apt/lists/*;
COPY ./dockerfiles/php/php-fpm.conf /usr/local/etc/php-fpm.conf
COPY ./app /app
WORKDIR /app

