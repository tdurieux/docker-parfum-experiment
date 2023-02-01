FROM php:7.2.0-fpm
MAINTAINER Mofesola Babalola <me@mofesola.com>

RUN apt update && apt install --no-install-recommends -y wget gnupg && rm -rf /var/lib/apt/lists/*;
RUN wget -O- https://download.newrelic.com/548C16BF.gpg | apt-key add -
RUN echo "deb http://apt.newrelic.com/debian/ newrelic non-free" >> /etc/apt/sources.list.d/newrelic.list

RUN apt update && apt install --no-install-recommends -y git \
                                 zip \
                                 gettext \
                                 newrelic-php5 \
                                 libxml2-dev \
                                 libc-client-dev \
                                 libkrb5-dev \
                                 openssl \
                                 netcat && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
        && docker-php-ext-install pdo pdo_mysql soap mbstring tokenizer xml imap

RUN pecl install xdebug-2.9.0

RUN newrelic-install install
COPY scripts/newrelic.ini /usr/local/etc/php/conf.d/

WORKDIR /var/www/html/handesk

COPY . /var/www/data
COPY scripts/start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 9000

ENTRYPOINT /start.sh
