FROM phalconphp/php:alpine-php7-min

COPY . /phapp
WORKDIR /phapp

RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    composer install
