FROM php:7.4-fpm

RUN apt update \
    && apt install --no-install-recommends -y \
        libjpeg-progs \
        djvulibre-bin \
        imagemagick \
        libmagickwand-dev \
        exiftool \
        libzip-dev \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && docker-php-ext-install exif \
    && docker-php-ext-enable exif \
    && docker-php-ext-install zip \
    && docker-php-ext-enable zip && rm -rf /var/lib/apt/lists/*;

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && rm composer-setup.php \
    && mv composer.phar /usr/local/bin/composer
