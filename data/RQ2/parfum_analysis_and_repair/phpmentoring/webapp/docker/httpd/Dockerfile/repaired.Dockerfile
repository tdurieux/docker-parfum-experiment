FROM php:7.1-apache

RUN a2enmod rewrite && \
    sed -i "s/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/public/" /etc/apache2/sites-enabled/000-default.conf && \
    mkdir -p /var/www/data/logs && \
    chown www-data:www-data /var/www/data/logs && \
    apt-get update && \
    apt-get install --no-install-recommends -y libzip-dev libicu-dev libxml2-dev libcurl4-openssl-dev libjpeg-dev libpng12-dev && \
    docker-php-ext-install mbstring zip gd intl xml curl json pdo pdo_mysql && pecl install -o -f xdebug && docker-php-ext-enable xdebug && rm -rf /var/lib/apt/lists/*;

WORKDIR /var/www/public