FROM php:7.0-fpm

ADD ./laravel.ini /usr/local/etc/php/conf.d

RUN apt-get update && apt-get install --no-install-recommends -y \
    software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y --force-yes \
    git \
    libicu52 \
    libicu-dev \
    libmcrypt-dev \
    mcrypt \
    zlib1g \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-install \
    intl \
    mcrypt \
    pdo_mysql \
    zip

RUN curl -f -s https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/ \
    && echo "alias composer='/usr/local/bin/composer.phar'" >> ~/.bashrc

RUN usermod -u 1000 www-data

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /var/www/mpt

CMD ["php-fpm"]

EXPOSE 9000
