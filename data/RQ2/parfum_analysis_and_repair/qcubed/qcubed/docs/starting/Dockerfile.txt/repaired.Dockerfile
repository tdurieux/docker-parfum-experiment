FROM php:7.0-apache
RUN apt-get update && apt-get install --no-install-recommends -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd && rm -rf /var/lib/apt/lists/*;

# imagick install   
RUN apt-get install -y \
            libmagickwand-dev \
        --no-install-recommends \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && rm -r /var/lib/apt/lists/*

# Apcu memory cache installation. Other caches are possible, like Redis or MemCache
RUN pecl install apcu
RUN docker-php-ext-enable apcu

# xdebug install
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug
COPY xdebug.ini /usr/local/etc/php/conf.d

# mysql client install
RUN apt-get update && apt-get install --no-install-recommends -y mysql-client libmysqlclient-dev \
      && docker-php-ext-install mysqli && rm -rf /var/lib/apt/lists/*;

# ghostscript install     
RUN apt-get update && apt-get install --no-install-recommends -y ghostscript && rm -rf /var/lib/apt/lists/*;

# This intl stuff is needed for running phpDocumentor from composer install (possibly)
# Its not required for regular QCubed work.
RUN apt-get update \
  && apt-get install --no-install-recommends -y zlib1g-dev libicu-dev g++ \
  && docker-php-ext-configure intl \
  && docker-php-ext-install intl && rm -rf /var/lib/apt/lists/*;

# enable apache rewrite
RUN a2enmod rewrite

# setup personal environment variables
ENV APP_ENV dev
ENV PHP_IDE_CONFIG "serverName=localhost"

EXPOSE 9000

RUN apt-get clean