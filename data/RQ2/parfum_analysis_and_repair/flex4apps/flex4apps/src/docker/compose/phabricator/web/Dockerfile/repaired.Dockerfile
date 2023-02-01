# download base image ubuntu 16.10
FROM php:7.1-apache
RUN apt-get update
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

WORKDIR /repo
RUN git clone https://github.com/phacility/libphutil.git
RUN git clone https://github.com/phacility/arcanist.git
RUN git clone https://github.com/phacility/phabricator.git

RUN a2enmod rewrite
RUN chown -R www-data /repo
RUN chgrp -R www-data /repo


# mysqli extension
RUN docker-php-ext-install -j$(nproc) mysqli

# GD extension
RUN apt-get -y --no-install-recommends install libfreetype6-dev libjpeg62-turbo-dev libpng-dev && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN pecl install apcu
RUN apt-get install --no-install-recommends -y python3-pygments && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y sendmail && rm -rf /var/lib/apt/lists/*;

WORKDIR /repo/phabricator

# apache config
RUN sed -i 's#DocumentRoot /var/www/html#DocumentRoot /repo/phabricator/webroot\nRewriteEngine on\nRewriteRule ^(.*)$          /index.php?__path__=$1  [B,L,QSA]\n<Directory "/repo/phabricator/webroot">\n  Require all granted\n</Directory>#g' /etc/apache2/sites-enabled/000-default.conf

# ssl reverse proxy - preabmle
RUN echo \<?php >> support/preamble.php
RUN echo \$_SERVER[\'REMOTE_ADDR\'] = \$_SERVER[\'HTTP_X_FORWARDED_FOR\']\; >> support/preamble.php
RUN echo \$_SERVER[\'HTTPS\'] = true\; >> support/preamble.php

# phabricator configuration
RUN ./bin/config set mysql.host mariadb.f4a.me
RUN ./bin/config set mysql.user phabricator
RUN ./bin/config set mysql.pass ...
RUN ./bin/config set mysql.port 3306
RUN ./bin/config set phabricator.base-uri https://phabricator.f4a.me

RUN ./bin/config set phpmailer.smtp-host home.tillwitt.de
RUN ./bin/config set phpmailer.smtp-protocol TLS
RUN ./bin/config set phpmailer.smtp-port 587
RUN ./bin/config set phpmailer.smtp-user notify
RUN ./bin/config set phpmailer.smtp-password ...


ADD start.sh .
RUN chmod 755 start.sh

ENTRYPOINT ./start.sh && /bin/bash
