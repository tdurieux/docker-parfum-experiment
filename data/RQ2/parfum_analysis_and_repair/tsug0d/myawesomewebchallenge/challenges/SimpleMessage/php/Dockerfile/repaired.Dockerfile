FROM php:5-apache
COPY php.ini /usr/local/etc/php/
RUN apt-get update \
  && apt-get install --no-install-recommends -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev libmcrypt-dev \
  && docker-php-ext-install pdo_mysql mysqli mbstring gd iconv && rm -rf /var/lib/apt/lists/*;
