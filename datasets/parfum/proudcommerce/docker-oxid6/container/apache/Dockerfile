FROM php:8.0-apache

MAINTAINER module@proudcommerce.com

# timezone / date   
RUN echo "Europe/Berlin" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

# install packages
RUN apt-get update -y && \
  apt-get install -y --no-install-recommends \
  less vim wget unzip rsync git default-mysql-client libzip-dev ssl-cert \
  libcurl4-openssl-dev libfreetype6 libjpeg62-turbo libpng-dev libjpeg-dev libxml2-dev libxpm4 && \
  apt-get clean && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/* && \
  echo "export TERM=xterm" >> /root/.bashrc

# install php extensions
RUN docker-php-ext-configure gd --with-jpeg && \
  docker-php-ext-install -j$(nproc) zip bcmath soap pdo_mysql gd

# composer stuff
RUN php -r 'readfile("https://getcomposer.org/installer");' > composer-setup.php \
  && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
  && rm -f composer-setup.php \
  && chown www-data:www-data /var/www

# prepare entrypoint.d pattern
RUN mkdir /entrypoint.d
COPY ./files/entrypoint.sh /entrypoint.sh
COPY ./entrypoint.d/* /entrypoint.d/
RUN chmod 777 /entrypoint.sh && chmod 777 /entrypoint.d/*

# apache stuff
RUN /usr/sbin/a2enmod rewrite && /usr/sbin/a2enmod headers && /usr/sbin/a2enmod expires && /usr/sbin/a2enmod ssl
COPY ./files/000-default.conf /etc/apache2/sites-available/000-default.conf

# oxid stuff
COPY ./files/config.inc.php /var/www/config.inc.php

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
