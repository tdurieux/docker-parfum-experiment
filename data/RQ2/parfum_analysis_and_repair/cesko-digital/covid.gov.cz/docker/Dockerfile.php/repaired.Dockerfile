FROM php:7.3-fpm

WORKDIR /

COPY ./php/php.ini  /usr/local/etc/php/php.ini
COPY ./php/www.conf /usr/local/etc/php-fpm.d/www.conf

WORKDIR /var/www/html

USER root

RUN useradd -u 1001 -r -g 0 -d /app -s /sbin/nologin -c "Default Application User" default && \
mkdir -p /app && \
chown -R 1001:0 /app

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates wget apt-transport-https gnupg apt-utils && rm -rf /var/lib/apt/lists/*;
# Add Microsoft repositories
RUN curl -f https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl -f https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN chown 1001:1001 /var/www
RUN apt-get update
RUN apt-get install --no-install-recommends -y libpng-dev libjpeg-dev libwebp-dev libpq-dev patch libzip-dev libfontconfig libxslt-dev lsof git git-core libbz2-dev vim mc libxrender1 && rm -rf /var/lib/apt/lists/*;
RUN ACCEPT_EULA=Y apt-get --no-install-recommends install -y --allow-unauthenticated msodbcsql17 unixodbc-dev && rm -rf /var/lib/apt/lists/*;
RUN pecl install sqlsrv pdo_sqlsrv \
   && docker-php-ext-configure bcmath --enable-bcmath \
   && docker-php-ext-configure gd --with-webp-dir=/usr --with-jpeg-dir=/usr \
   && docker-php-ext-install gd mbstring opcache zip xsl bz2 exif  bcmath \
   && docker-php-ext-enable sqlsrv pdo_sqlsrv \
   && curl -fSL "https://github.com/drush-ops/drush-launcher/releases/download/0.6.0/drush.phar" -o /usr/local/bin/drush \
   && chmod +x /usr/local/bin/drush \
   && curl -fSL "https://getcomposer.org/download/1.9.1/composer.phar" -o /usr/local/bin/composer \
   && chmod +x /usr/local/bin/composer \
   && curl -fSL "https://github.com/hechoendrupal/drupal-console-launcher/releases/download/1.9.4/drupal.phar" -o /usr/local/bin/drupal \
   && chmod +x /usr/local/bin/drupal \
   && mkdir /.composer \
   && mkdir /.config \
   && mkdir /.drush \
   && mkdir /.console \
   && chmod 777 /.composer \
   && chmod 777 /.config \
   && chmod 777 /.drush  \
   && chmod 777 /.console \
   && rm -rf /var/lib/apt/lists/*

USER 1001
