FROM php:%%PHP_VERSION%%-apache
LABEL maintainer="Francesco Bianco <info@javanile.org>"

ENV LAYER_BREAK=true
ENV VT_VERSION="%%VT_VERSION%%" \
    DATABASE_PACKAGE="%%DATABASE_PACKAGE%%" \
    COMPOSER_HOME=/usr/src/vtiger \
    PATH="/usr/src/vtiger/vendor/bin:$PATH"

COPY php.ini /usr/local/etc/php/
COPY vtiger.json .symvol /usr/src/vtiger/
COPY vtiger-ssl.* /etc/apache2/ssl/
COPY 000-default.conf /etc/apache2/sites-available/

RUN apt-get update && \
    apt-get install --no-install-recommends -y libzip-dev zlib1g-dev libc-client-dev libkrb5-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libxml2-dev cron rsyslog zip unzip socat vim nano && \
    docker-php-ext-configure gd && ${LAYER_BREAK} && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install imap exif mysqli pdo pdo_mysql zip gd xml && \
    echo "cron.* /var/log/cron.log" >> /etc/rsyslog.conf && rm -fr /etc/cron.* && mkdir /etc/cron.d && ${LAYER_BREAK}
RUN curl -f -o composer -sL https://getcomposer.org/composer.phar && \
    php composer global require javanile/http-robot:0.0.2 javanile/mysql-import:0.0.15 javanile/vtiger-cli:0.0.4 && \
    php composer clearcache && rm composer && ${LAYER_BREAK}
RUN curl -f -sL https://javanile.github.io/symvol/setup.sh?v=0.0.2 | bash - && ${LAYER_BREAK}
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    a2enmod ssl && a2enmod rewrite && ${LAYER_BREAK}
RUN cd /usr/src/vtiger && \
    curl -f -o vtiger.tar.gz -L "%%VT_DOWNLOAD%%" && \
    tar -xzf vtiger.tar.gz && \
    rm vtiger.tar.gz && \
    rm -fr /var/www/html && \
    mv "%%VT_DIRECTORY%%" /var/www/html && \
    vtiger permissions --fix && \
    mv .symvol /var/www/html && \
    mkdir -p volume /var/lib/vtiger && ${LAYER_BREAK}
RUN apt-get clean && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

## @block: develop
COPY develop-install.sh /usr/local/bin/
RUN develop-install.sh
#COPY vtiger-install.sh /usr/local/bin/
#COPY vtiger-install.php /usr/src/vtiger/
## @block: release
COPY health.php polyfill.php /var/www/html/
COPY vtiger-*.sh /usr/local/bin/
COPY vtiger-*.php /usr/src/vtiger/
## @endblock

## @block: develop
RUN vtiger-install.sh --assert-mysql --dump --remove-mysql
#COPY vtiger-foreground.sh /usr/local/bin/
#COPY vtiger-functions.php /usr/src/vtiger/
## @block: release
#RUN vtiger-install.sh --install-mysql --assert-mysql --dump --remove-mysql && ${LAYER_BREAK}
## @endblock
RUN cd /var/www/html/vtlib/Vtiger/ && \
    sed -e 's!realpath(!__realpath__(!' -ri Utils.php Deprecated.php && \
    symvol move /var/www/html /usr/src/vtiger/volume

COPY config.inc.php /usr/src/vtiger/
COPY LoggerManager.php /var/www/html/libraries/log4php/
COPY config.performance.php health.php loading.php  /var/www/html/
COPY crontab /etc/

VOLUME ["/var/lib/vtiger"]

WORKDIR /app

ENV VT_ADMIN_USER="admin" \
    VT_ADMIN_PASSWORD="admin" \
    VT_ADMIN_EMAIL="admin@localhost.lan" \
    VT_CURRENCY_NAME="USA, Dollars" \
    VT_SCHEDULER=1 \
    VT_INSTALL=1 \
    MYSQL_HOST="mysql" \
    MYSQL_DATABASE="vtiger"

CMD ["vtiger-foreground.sh"]
