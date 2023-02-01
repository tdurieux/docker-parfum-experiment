FROM php:7.3.14-fpm
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list
RUN sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y make g++ procps telnet iputils-ping zip unzip vim

ARG EXT_DIR=/usr/src/php/ext/
#  install tideways_xhprof
RUN docker-php-source extract
ADD ./php-xhprof-extension.tar.gz ${EXT_DIR}
RUN docker-php-ext-install php-xhprof-extension && docker-php-ext-enable tideways_xhprof
RUN docker-php-ext-install mysqli 
COPY ./mongodb-1.7.5.tgz /home
RUN pecl install /home/mongodb-1.7.5.tgz && docker-php-ext-enable mongodb
COPY ./install_composer.sh /home
RUN chmod +x /home/install_composer.sh
RUN /home/install_composer.sh

RUN pecl install xdebug && docker-php-ext-enable xdebug

WORKDIR /home/xhgui-branch

# RUN composer install --prefer-dist