COPY --chown=www-data:www-data . /var/www/html

USER www-data
RUN composer install --no-dev --no-scripts --no-suggest --classmap-authoritative --no-interaction

USER root