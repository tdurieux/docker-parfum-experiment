FROM php:7.3-fpm-alpine

RUN apk update && apk add --no-cache \
  ldb-dev \
  openldap-dev \
  libxml2-dev \
  curl-dev \
  openssl-dev \
  libzip-dev \
  curl-dev \
  icu-dev \
  samba-dev \
  samba-client \
  gmp-dev \
  autoconf \
  libzip \
  icu-libs \
  libstdc++ \
  g++ \
  git \
  coreutils \
  bash \
  make \
  curl \
  freetype-dev libpng-dev libjpeg-turbo-dev \
  imagemagick \
  imagemagick-dev

RUN docker-php-ext-install ldap xml opcache curl zip intl sockets pcntl sysvmsg gmp

RUN pecl install mongodb \
    && pecl install apcu \
    && pecl install imagick \
    && pecl install smbclient \
    && docker-php-ext-enable mongodb apcu imagick smbclient

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.overload_var_dump=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && ln -s /srv/www/balloon/config/php.ini /usr/local/etc/php/conf.d/zz-custom.ini

RUN git clone https://github.com/gyselroth/php-serializable-md5 \
    && docker-php-source extract \
    && cd php-serializable-md5 \
    && phpize \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make install \
    && echo "extension=smd5.so" > /usr/local/etc/php/conf.d/docker-php-ext-smd5.ini \
    && cd .. \
    && rm -rfv php-serializable-md5

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php composer-setup.php --filename=composer --install-dir=/usr/bin \
  && php -r "unlink('composer-setup.php');"

RUN mkdir /var/cache/samba/msg.lock

EXPOSE 9000

CMD make -C /srv/www/balloon deps; \
  php /srv/www/balloon/src/cgi-bin/cli.php upgrade start -i; \
  php-fpm
