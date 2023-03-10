FROM php:5.6-apache

RUN adduser --home /home/web --shell /bin/bash --disabled-password web
RUN usermod -a -G www-data web

# Enable Apache mod rewrite
RUN a2enmod rewrite

# Setup and install core packages
RUN apt-get update
RUN apt-get -y --no-install-recommends install zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install ssh && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install phpunit && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install locate && rm -rf /var/lib/apt/lists/*;
RUN updatedb

COPY docker/www/install-composer.sh /root/install-composer.sh
RUN chmod +x /root/install-composer.sh
RUN /root/install-composer.sh
RUN rm /root/install-composer.sh

RUN chmod g+w -R /var/www/html

# Install PHP extensions
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install mysql
RUN docker-php-ext-install zip

COPY docker/www/php.ini /usr/local/etc/php/

COPY www/ /var/www/html/
RUN mv /var/www/html/config-dist.php /var/www/html/config.php
