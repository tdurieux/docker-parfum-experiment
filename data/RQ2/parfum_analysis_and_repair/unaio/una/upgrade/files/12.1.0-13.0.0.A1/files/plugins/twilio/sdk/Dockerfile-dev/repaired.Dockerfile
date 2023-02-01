ARG version
FROM php:$version

RUN curl -f --silent --show-error https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

RUN  apt-get update -y && \
     apt-get upgrade -y && \
     apt-get dist-upgrade -y && \
     apt-get -y autoremove && \
     apt-get clean

RUN apt-get install --no-install-recommends -y zip unzip git && rm -rf /var/lib/apt/lists/*;

ENV COMPOSER_ALLOW_SUPERUSER=1
WORKDIR /twilio
