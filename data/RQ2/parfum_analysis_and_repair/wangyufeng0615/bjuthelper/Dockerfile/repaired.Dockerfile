#FROM php:7.2-fpm
FROM richarvey/nginx-php-fpm
MAINTAINER remini "i@iaside.com"

EXPOSE 80

#设置时区

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#更新安装依赖包和PHP核心拓展
#换源
#COPY sources.list .
#RUN  mv /etc/apt/sources.list /etc/apt/sources.list.bak && mv sources.list /etc/apt/

#RUN apt-get update && apt-get install -y \
#    git \
#    libfreetype6-dev \
#    libjpeg62-turbo-dev \
#    libpng-dev
#RUN docker-php-ext-install -j$(nproc) iconv \
#&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
#&& docker-php-ext-install -j$(nproc) gd \
#    && docker-php-ext-install zip \
#    && docker-php-ext-install pdo_mysql \
#    && docker-php-ext-install opcache \
#    && docker-php-ext-install mysqli \
#    && rm -r /var/lib/apt/lists/*



#安装 PECL 拓展，这里我们安装的是Redis和xdebug
#RUN pecl install redis-4.2.0RC1 \
#    && pecl install xdebug-2.7.0beta1 \
#    && docker-php-ext-enable redis xdebug

#安装第三方拓展，这里是 Phalcon 拓展

#RUN cd /home \
#&& tar -zxvf cphalcon.tar.gz \
#&& mv cphalcon-* phalcon \
#&& cd phalcon/build \
#&& ./install \
#&& echo "extension=phalcon.so" > /usr/local/etc/php/conf.d/phalcon.ini

#安装 Composer

#ENV COMPOSER_HOME /root/composer
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
#ENV PATH $COMPOSER_HOME/vendor/bin:$PATH

#RUN rm -f /home/redis.tgz \
#    rm -f /home/cphalcon.tar.gz

WORKDIR /var/www/html

COPY . .

#Write Permission

#RUN usermod -u 1000 www-data

#CMD php-fpm