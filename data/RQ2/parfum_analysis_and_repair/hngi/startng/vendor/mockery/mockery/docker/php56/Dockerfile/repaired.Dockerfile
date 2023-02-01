FROM php:5.6-cli

RUN apt-get update && \
    apt-get install --no-install-recommends -y git zip unzip && \
    apt-get -y autoremove && \
    apt-get clean && \
    curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /opt/mockery

COPY composer.json ./

RUN composer install
