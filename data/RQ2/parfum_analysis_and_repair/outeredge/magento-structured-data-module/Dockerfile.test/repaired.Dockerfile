FROM outeredge/edge-docker-php:7.1.7

COPY composer.* /var/www/

RUN composer install --no-interaction --no-autoloader --prefer-dist

COPY . /var/www/