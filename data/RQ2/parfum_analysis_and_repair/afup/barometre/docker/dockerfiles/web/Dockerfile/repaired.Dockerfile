FROM php:8.0-apache

RUN apt-get update && apt-get install --no-install-recommends -y zlib1g zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN echo "date.timezone=Europe/Paris" >> "/usr/local/etc/php/php.ini"
RUN docker-php-ext-install pdo_mysql
RUN apt-get update && apt-get install --no-install-recommends -y libicu-dev build-essential && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install intl
RUN echo "Include sites-enabled/" >> /etc/apache2/apache2.conf
RUN a2enmod rewrite

ARG uid=1008

RUN usermod -u ${uid} www-data

COPY apache.conf /etc/apache2/sites-enabled/000-default.conf
