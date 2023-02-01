FROM php:8.1-apache

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions pdo_pgsql intl

RUN curl -f -sSk https://getcomposer.org/installer | php -- --disable-tls && \
   mv composer.phar /usr/local/bin/composer

RUN apt update && apt install --no-install-recommends -yqq nodejs npm && rm -rf /var/lib/apt/lists/*;

COPY . /var/www/

COPY ./docker/apache.conf /etc/apache2/sites-available/000-default.conf

RUN cd /var/www && \
    composer install && \
    npm install --force && \
    npm run build && npm cache clean --force;

WORKDIR /var/www/

ENTRYPOINT ["bash", "./docker/docker.sh"]

EXPOSE 80