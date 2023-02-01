FROM php:8.1-fpm

RUN apt-get update

RUN apt-get install --no-install-recommends -y \
        git \
        libzip-dev \
        unzip \
        rsync \
        && docker-php-ext-install opcache \
        && docker-php-ext-install zip && rm -rf /var/lib/apt/lists/*;

# Install GD
RUN apt-get install --no-install-recommends -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libxpm-dev && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ \
                                --with-jpeg=/usr/include/ \
                                --with-xpm=/usr/include/ \
                                --enable-gd-jis-conv \
    && docker-php-ext-install gd

RUN pecl install xdebug-3.1.2 \
    && docker-php-ext-enable xdebug

RUN apt-get install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;

COPY --from=composer /usr/bin/composer /usr/bin/composer

COPY config/php.ini /usr/local/etc/php/conf.d/
WORKDIR /whatsapp
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "bash", "/usr/local/bin/entrypoint.sh" ]
