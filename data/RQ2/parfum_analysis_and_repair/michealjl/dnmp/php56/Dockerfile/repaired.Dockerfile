FROM php:5.6-fpm

RUN apt-get update -yqq && \
    apt-get install --no-install-recommends -y apt-utils && \
    pecl channel-update pecl.php.net && rm -rf /var/lib/apt/lists/*;

USER root

RUN apt-get install --no-install-recommends libzip-dev zip unzip -y && \
    apt-get install --no-install-recommends -y libfreetype6-dev libmcrypt-dev libjpeg-dev libpng-dev && \
    docker-php-ext-configure zip --with-libzip && \
    # Install GD
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/freetype2 --with-png-dir=/usr/include --with-jpeg-dir=/usr/include && \
    # Install the zip extension
    docker-php-ext-install zip mysqli pdo_mysql gd && rm -rf /var/lib/apt/lists/*;


ARG INSTALL_PHPREDIS=${INSTALL_PHPREDIS}

RUN if [ ${INSTALL_PHPREDIS} = true ]; then \
    # Install Php Redis Extension
    printf "\n" | pecl install -o -f redis-4.0.1 \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis \
;fi

ARG INSTALL_SWOOLE=${INSTALL_SWOOLE}

RUN if [ ${INSTALL_SWOOLE} = true ]; then \
    # Install Php Swoole Extension
    if [ $(php -r "echo PHP_MAJOR_VERSION;") = "5" ]; then \
      pecl install swoole-2.0.11; \
    else \
      if [ $(php -r "echo PHP_MINOR_VERSION;") = "0" ]; then \
        pecl install swoole-2.2.0; \
      else \
        pecl install swoole; \
      fi \
    fi && \
    docker-php-ext-enable swoole \
;fi

USER root

ARG INSTALL_IMAGEMAGICK=${INSTALL_IMAGEMAGICK}

RUN if [ ${INSTALL_IMAGEMAGICK} = true ]; then \
    apt-get install --no-install-recommends -y libmagickwand-dev imagemagick && \
    pecl install imagick && \
    docker-php-ext-enable imagick \
; rm -rf /var/lib/apt/lists/*; fi

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /var/log/lastlog /var/log/faillog

RUN usermod -u 1000 www-data

CMD ["php-fpm"]

EXPOSE 9000
