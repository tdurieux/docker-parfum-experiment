FROM php:7.4

RUN apt-get update && \
    apt-get install --no-install-recommends -y mariadb-client zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN yes | pecl install xdebug-2.8.0
RUN echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini
RUN echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini
RUN echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/xdebug.ini

# Install extensions through the scripts the container provides
RUN docker-php-ext-install pdo_mysql zip
