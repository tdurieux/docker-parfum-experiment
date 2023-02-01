FROM php:7.3.14-fpm
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list
RUN sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y make g++ procps telnet iputils-ping google-perftools libzip-dev zip vim \
# RUN apt-get update && apt-get upgrade -y make g++ procps telnet iputils-ping \
nginx redis-server

# dpkg -l | grep tzdata
ENV TZ="Asia/Shanghai"
RUN echo "set mouse-=a" >> ~/.vimrc 
RUN echo 'alias tailf="tail -f"' >> ~/.bashrc
RUN mkdir -p /data/log/


COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/conf.d /etc/nginx/conf.d

COPY ./redis/redis.conf /usr/local/etc/redis/redis.conf

COPY ./php/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./php/php.ini /usr/local/etc/php/php.ini

RUN echo "LD_PRELOAD=/usr/lib/libtcmalloc.so.4" | tee -a /etc/environment

ARG EXT_DIR=/usr/src/php/ext/

#  install composer
COPY ./install_composer.sh /home
RUN chmod +x /home/install_composer.sh
RUN /home/install_composer.sh

#  install tideways_xhprof
RUN docker-php-source extract
ADD ./tgz/php-xhprof-extension.tar.gz ${EXT_DIR}
RUN docker-php-ext-install php-xhprof-extension
# RUN docker-php-ext-enable tideways_xhprof

# install sdebug
# ADD ./sdebug.tar.gz ${EXT_DIR}
# WORKDIR ${EXT_DIR}sdebug
# RUN sh rebuild.sh 

RUN docker-php-ext-install mysqli zip bcmath
COPY ./tgz/mongodb-1.7.5.tgz /home
RUN pecl install /home/mongodb-1.7.5.tgz && docker-php-ext-enable mongodb
COPY ./tgz/swoole-4.4.7.tgz /home
RUN pecl install /home/swoole-4.4.7.tgz && docker-php-ext-enable swoole
COPY ./tgz/redis-5.3.2.tgz /home
RUN pecl install /home/redis-5.3.2.tgz && docker-php-ext-enable redis
COPY ./tgz/protobuf-3.11.2.tgz /home
RUN pecl install /home/protobuf-3.11.2.tgz && docker-php-ext-enable protobuf

COPY entrypoint.sh /etc/entrypoint.sh
COPY sh/ /data/

RUN useradd -r nginx
RUN chmod +x /etc/entrypoint.sh

WORKDIR /data
EXPOSE 80
ENTRYPOINT ["/etc/entrypoint.sh"]