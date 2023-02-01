FROM php:8.1.5-alpine3.15
MAINTAINER Alejandro Celaya <alejandro@alejandrocelaya.com>

ENV APCU_VERSION 5.1.21
ENV INOTIFY_VERSION 3.0.0
ENV OPENSWOOLE_VERSION 4.11.1
ENV PDO_SQLSRV_VERSION 5.10.0
ENV MS_ODBC_SQL_VERSION 17.5.2.2

RUN apk update

# Install common php extensions
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install calendar

RUN apk add --no-cache oniguruma-dev
RUN docker-php-ext-install mbstring

RUN apk add --no-cache sqlite-libs
RUN apk add --no-cache sqlite-dev
RUN docker-php-ext-install pdo_sqlite

RUN apk add --no-cache icu-dev
RUN docker-php-ext-install intl

RUN apk add --no-cache libzip-dev zlib-dev
RUN docker-php-ext-install zip

RUN apk add --no-cache libpng-dev
RUN docker-php-ext-install gd

RUN apk add --no-cache postgresql-dev
RUN docker-php-ext-install pdo_pgsql

RUN docker-php-ext-install sockets
RUN docker-php-ext-install bcmath

# Install APCu extension
ADD https://pecl.php.net/get/apcu-$APCU_VERSION.tgz /tmp/apcu.tar.gz
RUN mkdir -p /usr/src/php/ext/apcu \
  && tar xf /tmp/apcu.tar.gz -C /usr/src/php/ext/apcu --strip-components=1 \
  && docker-php-ext-configure apcu \
  && docker-php-ext-install apcu \
  && rm /tmp/apcu.tar.gz \
  && rm /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini \
  && echo extension=apcu.so > /usr/local/etc/php/conf.d/20-php-ext-apcu.ini && rm -rf /usr/src/php/ext/apcu

# Install inotify extension
ADD https://pecl.php.net/get/inotify-$INOTIFY_VERSION.tgz /tmp/inotify.tar.gz
RUN mkdir -p /usr/src/php/ext/inotify \
  && tar xf /tmp/inotify.tar.gz -C /usr/src/php/ext/inotify --strip-components=1 \
  && docker-php-ext-configure inotify \
  && docker-php-ext-install inotify \
  && rm /tmp/inotify.tar.gz && rm -rf /usr/src/php/ext/inotify

# Install openswoole, pcov and mssql driver
RUN wget https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_${MS_ODBC_SQL_VERSION}-1_amd64.apk && \
    apk add --no-cache --allow-untrusted msodbcsql17_${MS_ODBC_SQL_VERSION}-1_amd64.apk && \
    apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS unixodbc-dev && \
    pecl install openswoole-${OPENSWOOLE_VERSION} pdo_sqlsrv-${PDO_SQLSRV_VERSION} pcov && \
    docker-php-ext-enable openswoole pdo_sqlsrv pcov && \
    apk del .phpize-deps && \
    rm msodbcsql17_${MS_ODBC_SQL_VERSION}-1_amd64.apk

# Install composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# Make home directory writable by anyone
RUN chmod 777 /home

VOLUME /home/shlink
WORKDIR /home/shlink

# Expose openswoole port
EXPOSE 8080

CMD \
    # Install dependencies if the vendor dir does not exist
    if [[ ! -d "./vendor" ]]; then /usr/local/bin/composer install ; fi && \
    # When restarting the container, openswoole might think it is already in execution
    # This forces the app to be started every second until the exit code is 0
    until php ./vendor/bin/laminas mezzio:swoole:start; do sleep 1 ; done
