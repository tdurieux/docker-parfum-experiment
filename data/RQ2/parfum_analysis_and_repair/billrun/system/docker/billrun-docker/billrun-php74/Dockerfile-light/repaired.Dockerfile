from php:7.4-fpm
# https://github.com/netroby/docker-php-fpm/blob/master/Dockerfile

RUN apt-get update && apt-get install --no-install-recommends -y \
        wkhtmltopdf \
    && pecl install yaf \
    && pecl install mongodb \
    && docker-php-ext-enable yaf mongodb \
    && docker-php-ext-install pcntl bcmath && rm -rf /var/lib/apt/lists/*;

COPY php-fpm.conf /usr/local/etc/
COPY php.ini /usr/local/etc/php/
CMD ["php-fpm"]
