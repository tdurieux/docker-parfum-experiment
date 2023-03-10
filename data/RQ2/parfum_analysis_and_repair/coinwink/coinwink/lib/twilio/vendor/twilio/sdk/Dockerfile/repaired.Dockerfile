FROM php:5.6

RUN mkdir /twilio
WORKDIR /twilio

COPY Twilio ./Twilio
COPY Services ./Services
COPY composer* ./

RUN curl -f --silent --show-error https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN composer install --no-dev
