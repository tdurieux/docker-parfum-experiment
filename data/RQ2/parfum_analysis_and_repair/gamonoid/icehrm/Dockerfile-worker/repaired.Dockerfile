FROM alpine:3.11
LABEL Maintainer="Thilina, Pituwala <thilina@icehrm.com>" \
      Description="IceHrm Docker Container with Nginx 1.16 & PHP-FPM 7.3 based on Alpine Linux."

ARG EXE_ENV

RUN apk upgrade --available

RUN apk add --no-cache tini openrc busybox-initscripts


# Install packages
RUN apk --no-cache add php7 php7-opcache php7-mysqli php7-json php7-openssl php7-curl \
    php7-zlib php7-xml php7-phar php7-intl php7-dom php7-xmlreader php7-ctype php7-session \
    php7-mbstring php7-gd curl

# Setup document root
RUN mkdir -p /var/www/html

# Add application
WORKDIR /var/www/html
COPY ./app /var/www/html/app/
COPY ./core /var/www/html/core/
COPY ./web /var/www/html/web/
COPY ./index.php /var/www/html/index.php
COPY ./docker/$EXE_ENV/config/config.php /var/www/html/app/config.php


COPY ./docker/worker/config/ice-cron /etc/crontabs/root

CMD /usr/sbin/crond -f -l 8