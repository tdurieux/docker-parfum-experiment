FROM totara/docker-dev-php56:latest

RUN pecl install -f xdebug-2.5.5 && docker-php-ext-enable xdebug.so

RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=0" >> /usr/local/etc/php/conf.d/xdebug.ini