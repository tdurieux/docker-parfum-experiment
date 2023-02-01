FROM php:7.3-apache
COPY ./php.ini /usr/local/etc/php/
RUN apt-get update \
  && apt-get install --no-install-recommends -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev libmcrypt-dev && rm -rf /var/lib/apt/lists/*;
