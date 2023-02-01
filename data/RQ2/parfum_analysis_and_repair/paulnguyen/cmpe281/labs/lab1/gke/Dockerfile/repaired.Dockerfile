FROM php:7.2-apache
EXPOSE 80
RUN apt-get update -y && apt-get install --no-install-recommends stress -y && rm -rf /var/lib/apt/lists/*;
RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY ./*.html /var/www/html/
COPY ./*.php /var/www/html/

