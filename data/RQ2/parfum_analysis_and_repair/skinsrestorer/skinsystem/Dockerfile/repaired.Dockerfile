FROM php:apache
RUN rm /etc/apt/preferences.d/no-debian-php
RUN apt-get update && apt-get install --no-install-recommends -y php-gd php-curl php-mysql && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install mysqli pdo pdo_mysql
COPY --chown=www-data:www-data . /var/www/html/
