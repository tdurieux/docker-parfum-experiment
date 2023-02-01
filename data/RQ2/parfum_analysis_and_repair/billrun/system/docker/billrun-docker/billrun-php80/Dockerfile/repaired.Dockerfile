from php:8.0-fpm
# https://github.com/netroby/docker-php-fpm/blob/master/Dockerfile

RUN apt-get update && apt-get install --no-install-recommends -y \
        wkhtmltopdf \
    && pecl install yaf \
    && pecl install mongodb \
    && pecl install xdebug \
    && docker-php-ext-enable yaf mongodb xdebug \
    && docker-php-ext-install pcntl bcmath && rm -rf /var/lib/apt/lists/*;

COPY php-fpm.conf /usr/local/etc/
COPY php.ini /usr/local/etc/php/
COPY xdebug.ini /usr/local/etc/php/conf.d/
CMD ["php-fpm"]
