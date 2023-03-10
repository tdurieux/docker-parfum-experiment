FROM nextcloud:20-apache

COPY entrypoint.sh /

RUN deluser www-data
RUN useradd -u 1000 -ms /bin/bash www-data
RUN usermod -a -G www-data www-data
RUN mkdir /var/www/deploy