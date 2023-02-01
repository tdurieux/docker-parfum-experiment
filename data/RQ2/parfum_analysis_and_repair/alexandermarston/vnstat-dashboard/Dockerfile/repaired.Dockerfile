FROM php:7.0-apache

MAINTAINER Alex Marston <alexander.marston@gmail.com>

# Install Git
RUN apt-get update && apt-get install --no-install-recommends -y git unzip && rm -rf /var/lib/apt/lists/*;

# Install Composer to handle dependencies
RUN curl -f -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Copy application source code to html directory
COPY ./app/ /var/www/html/

# Install dependencies
RUN composer install

RUN mkdir -p /var/lib/vnstat
