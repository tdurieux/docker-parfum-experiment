FROM richarvey/nginx-php-fpm

RUN apt-get update && apt-get install --no-install-recommends -y php5-mongo php5-curl && rm -rf /var/lib/apt/lists/*;
ADD . /var/www/
RUN chown www-data:www-data -R /var/www/

ADD Docker/nginx-ct.conf /etc/nginx/conf.d/nginx-ct.conf
ADD Docker/database.php /var/www/app/config/database.php

# Install composer
RUN chmod +x /var/www/Docker/installComposer.sh
RUN chmod +x /var/www/Docker/initContainer.sh
RUN /var/www/Docker/installComposer.sh

USER www-data
WORKDIR /var/www/
RUN composer update
USER root
CMD ["/var/www/Docker/initContainer.sh"]
