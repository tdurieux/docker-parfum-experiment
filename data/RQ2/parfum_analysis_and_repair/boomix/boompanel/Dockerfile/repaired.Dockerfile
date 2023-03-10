FROM php:latest
VOLUME /boom/SERVER/cfg/sourcemod

RUN apt-get update && apt-get install --no-install-recommends -y nginx php7.0-fpm php7.0-mysql php7.0-bcm g++ libicu-dev mysql-client && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y

RUN docker-php-ext-configure pdo_mysql
RUN docker-php-ext-configure intl
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install intl
# RUN docker-php-ext-enable pdo_mysql
# RUN docker-php-ext-enable pdo_intl

COPY . /boom
COPY ./DOCKER/nginx_boom_panel.conf /etc/nginx/sites-available/default
COPY ./DOCKER/wait_for_mysql.sh ./wait_for_mysql.sh
COPY ./DOCKER/php.ini /usr/local/etc/php
COPY ./DOCKER/config.docker.php ./WEB/config.php

RUN chmod 777 -R /boom
RUN chmod 777 -R /usr/local/etc/php/
RUN chmod 777 -R /etc/nginx/sites-available/default
RUN chmod 777 -R /usr/local/etc/php
RUN chmod 777 ./wait_for_mysql.sh
RUN echo "cgi.fix_pathinfo: 0;" >> /etc/php/7.0/fpm/php.ini

ENV TIMEZONE="0" DEBUG="0" LANG="en" \
    DBHOST="localhost" DBNAME="boompanel" DBUSER="root" DBPASS=""

EXPOSE 80

CMD /bin/bash -c "./wait_for_mysql.sh ${DBHOST}:3306 && mysql --host ${DBHOST} -u ${DBUSER} -p${DBPASS} < /boom/database.sql && mysql --host ${DBHOST} -u ${DBUSER} -p${DBPASS} < /boom/database-update.sql && /etc/init.d/php7.0-fpm start && nginx -g 'daemon off;'"
