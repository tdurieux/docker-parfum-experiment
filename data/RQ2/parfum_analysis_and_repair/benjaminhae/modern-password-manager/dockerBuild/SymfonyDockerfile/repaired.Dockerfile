FROM php:8.1-apache
RUN docker-php-ext-install pdo_mysql

ENV APACHE_DOCUMENT_ROOT /app/public

RUN apt-get update && apt-get install -y --no-install-recommends ssl-cert && rm -rf /var/lib/apt/lists/*;

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
RUN a2enmod rewrite && \
    a2enmod ssl && \
    a2ensite default-ssl

COPY . /app
RUN mkdir /data && \
    echo "DATABASE_URL=\"sqlite:////data/pwman.sqlite\"" > /app/.env.local
RUN cd /app/ && php bin/console doctrine:schema:update --force
RUN chown -R www-data:www-data /app && chown -R www-data:www-data /data

