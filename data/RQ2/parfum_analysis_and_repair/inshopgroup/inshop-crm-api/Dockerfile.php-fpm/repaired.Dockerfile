FROM inshopgroup/docker-inshop-crm-api-php-fpm-prod:php7.4

WORKDIR /var/www
ADD ./ /var/www

RUN cp .env.dist .env
RUN composer install
RUN chown -R www-data:www-data /var/www