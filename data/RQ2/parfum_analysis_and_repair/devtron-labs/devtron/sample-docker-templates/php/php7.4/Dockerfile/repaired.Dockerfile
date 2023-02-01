FROM ubuntu:20.04

RUN apt-get update
RUN apt-get -y upgrade

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y --fix-missing php7.4 \
      php7.4-cli \
      php-fpm \
      php7.4-mysql \
      php7.4-curl \
      net-tools && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y nginx-full && rm -rf /var/lib/apt/lists/*;
ADD nginx-site.conf /etc/nginx/sites-available/default

WORKDIR /var/www/html/

RUN mkdir -p /run/php

COPY . /var/www/html

EXPOSE 80

CMD ["/bin/bash", "-c", "service php7.4-fpm start && nginx -g \"daemon off;\""]