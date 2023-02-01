FROM php:5.6.40
LABEL maintainer='Francesco Bianco <bianco@javanile.org>'

ENV VT_VERSION=6.0.0-RC \
    VT_DOWNLOAD=http://sourceforge.net/projects/vtigercrm/files/vtiger%20CRM%206.0%20RC/Core%20Product/vtigercrm-6.0.0rc.tar.gz \
    DATABASE_PACKAGE=mariadb-server-10.1 \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/usr/src/vtiger \
    PATH="/usr/src/vtiger/vendor/bin:$PATH"

COPY php.ini /usr/local/etc/php/
COPY .symvol vtiger.json /usr/src/vtiger/
COPY vtiger-ssl.* /etc/apache2/ssl/
COPY 000-default.conf /etc/apache2/sites-available/

WORKDIR /usr/src/vtiger

RUN apt-get update && \
    apt-get install --no-install-recommends -y zlib1g-dev libc-client-dev libkrb5-dev cron rsyslog unzip && \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install imap exif mysql mysqli pdo pdo_mysql zip && \
    curl -sL https://javanile.github.io/symvol/setup.sh?v=0.0.2 | bash - && \
    curl -o composer.phar -sL https://getcomposer.org/composer.phar && \
    php composer.phar --ansi global require javanile/http-robot:0.0.2 javanile/mysql-import:0.0.11 javanile/vtiger-cli:0.0.3 && \
    usermod -u 1000 www-data && groupmod -g 1000 www-data && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    curl -o vtiger.tar.gz -sL "$VT_DOWNLOAD" && tar -xzf vtiger.tar.gz && rm vtiger.tar.gz && \
    rm -fr /var/www/html && mv "vtigerCRM" /var/www/html && \
    echo vtiger permissions --fix && \
    a2enmod ssl && a2enmod rewrite && \
    apt-get clean && echo php composer.phar clearcache && \
    mv /usr/src/vtiger/.symvol /var/www/html && \
    mkdir -p volume /var/lib/vtiger && \
    chmod 777 -R /var/www/html && \
    rm -rf composer.phar /tmp/* /var/tmp/* /var/lib/apt/lists/* /etc/cron.*

COPY develop-install.sh /usr/local/bin/
RUN develop-install.sh
COPY vtiger-install.sh /usr/local/bin/
COPY vtiger-install.php /usr/src/vtiger/
COPY vtiger-functions.php /usr/src/vtiger/
COPY health.php /var/www/html/
COPY crontab /etc/cron.d/crontab

RUN sed -i 's/^error_reporting = .*$/error_reporting = E_ALL \& ~E_WARNING \& ~E_NOTICE \& ~E_DEPRECATED \& ~E_STRICT/' /usr/local/etc/php/php.ini
RUN sed -i 's/^log4php\.rootLogger=.*$/log4php.rootLogger=ALL,A1/' /var/www/html/log4php.properties
RUN sed -i 's/^log4php\.logger\.INSTALL=.*$/log4php.logger.INSTALL=ALL,A3/' /var/www/html/log4php.properties


RUN vtiger-install.sh --assert-mysql --dump --remove-mysql
COPY vtiger-foreground.sh vtiger-schedule.sh /usr/local/bin/
COPY LoggerManager.php /var/www/html/libraries/log4php/
COPY config.inc.php /usr/src/vtiger/
COPY config.performance.php loading.php /var/www/html/

RUN cd /var/www/html/vtlib/Vtiger/ && \
    sed -e 's!realpath(!__realpath__(!' -ri Utils.php Deprecated.php && \
    mv /usr/local/bin/vtiger-schedule.sh /usr/local/bin/schedule && \
    symvol move /var/www/html /usr/src/vtiger/volume

RUN echo "<?php phpinfo();" > /var/www/html/phpinfo.php

VOLUME ["/var/lib/vtiger"]

WORKDIR /app

ENV VT_ADMIN_USER='admin' \
    VT_ADMIN_PASSWORD='admin' \
    VT_ADMIN_EMAIL='admin@localhost.lan' \
    VT_CURRENCY_NAME='USA, Dollars' \
    VT_INSTALL=1 \
    VT_SCHEDULER=1 \
    MYSQL_HOST='mysql' \
    MYSQL_DATABASE='vtiger'

CMD ["vtiger-foreground.sh"]
