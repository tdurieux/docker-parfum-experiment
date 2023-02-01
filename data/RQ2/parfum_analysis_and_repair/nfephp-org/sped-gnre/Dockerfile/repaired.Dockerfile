FROM php:7.3

WORKDIR /var/www

COPY . .

RUN apt-get update && \
    apt-get install --no-install-recommends -y libzip-dev libxml2-dev \
    libfreetype6-dev libjpeg62-turbo-dev \
    libgd-dev libpng-dev && \
    docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install -j$(nproc) zip soap gd && \
    curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && rm -rf /var/lib/apt/lists/*;

RUN pecl install xdebug \
    pecl install gmagick \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_host = host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

EXPOSE 8181

RUN composer install

CMD php -S 0.0.0.0:8181
