FROM php:7.2-apache
RUN apt-get update && \
    apt-get install -y \
        git \
        zlib1g-dev
WORKDIR /tls
RUN openssl req -new -x509 -days 365 -nodes \
  -out server.cert \
  -keyout server.key \
  -subj "/C=RO/ST=Bucharest/L=Bucharest/O=IT/CN=www.example.ro"
RUN docker-php-ext-install mysqli pdo pdo_mysql zip mbstring
RUN a2enmod rewrite
RUN a2enmod ssl
WORKDIR /install
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN git clone https://github.com/pdsinterop/php-solid-server /app
WORKDIR /app
RUN git checkout add-solid-crud-tests
RUN php /install/composer.phar install --no-dev --prefer-dist
COPY site.conf /etc/apache2/sites-enabled/site.conf
RUN chown -R www-data:www-data /app
EXPOSE 443
