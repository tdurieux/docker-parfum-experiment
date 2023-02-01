FROM php:7.2-apache

RUN apt-get update && \
    apt-get install --no-install-recommends -y libpng-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install gd
RUN docker-php-ext-install bcmath
