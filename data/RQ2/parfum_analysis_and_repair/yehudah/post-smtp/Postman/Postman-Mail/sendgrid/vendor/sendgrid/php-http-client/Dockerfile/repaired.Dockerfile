FROM php:7.1-apache

ARG sendgrid_apikey
ENV SENDGRID_API_KEY=$sendgrid_apikey

COPY . /var/www/client
WORKDIR /var/www/client

RUN apt-get update && \
    apt-get install --no-install-recommends -y git zip zlib1g-dev && docker-php-ext-install zip && rm -rf /var/lib/apt/lists/*;
RUN curl -f --silent --show-error https://getcomposer.org/installer | php

RUN php composer.phar install
