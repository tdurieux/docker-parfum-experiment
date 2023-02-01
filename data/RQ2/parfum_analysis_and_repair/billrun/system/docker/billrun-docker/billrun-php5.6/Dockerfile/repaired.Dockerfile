from php:5.6-fpm
# https://github.com/netroby/docker-php-fpm/blob/master/Dockerfile

RUN apt-get update && apt-get install --no-install-recommends -y \
        wkhtmltopdf \
#       openssl \
        libssl-dev \
    && pecl download yaf-2.3.5 && tar zxvf yaf-2.3.5.tgz && cd yaf-2.3.5 && phpize && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install \
    && pecl install mongo \
    && pecl install xdebug-2.5.5 \
    && docker-php-ext-enable yaf mongo xdebug && rm yaf-2.3.5.tgz && rm -rf /var/lib/apt/lists/*;

COPY php-fpm.conf /usr/local/etc/
COPY php.ini /usr/local/etc/php/
COPY xdebug.ini /usr/local/etc/php/conf.d/
CMD ["php-fpm"]
