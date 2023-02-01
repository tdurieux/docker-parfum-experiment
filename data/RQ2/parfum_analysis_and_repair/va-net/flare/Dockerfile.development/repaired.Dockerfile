FROM php:8-apache

RUN apt-get update && apt-get install --no-install-recommends -y libcurl3-dev libzip-dev zip && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install pdo_mysql curl zip
RUN a2enmod rewrite

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

CMD chown www-data:www-data -R /var/www/html/* && php /var/www/html/core/docker_entrypoint.php && apache2-foreground