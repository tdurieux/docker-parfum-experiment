FROM php:7.2-apache

RUN apt update && apt install --no-install-recommends -y gdal-bin && a2enmod rewrite && a2enmod ssl && rm -rf /var/lib/apt/lists/*;

COPY . /var/www/html/

VOLUME ["/var/www/html/config/projects"]
