FROM php:7.3-apache

WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends -y git zip unzip && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install pdo pdo_mysql mysqli
RUN a2enmod rewrite

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=. --filename=composer
RUN mv composer /usr/local/bin/

COPY composer.json composer.lock /app/

RUN composer install

RUN rm -rf /var/www/html && ln -s /app/public /var/www/html

# EXPOSE 80
