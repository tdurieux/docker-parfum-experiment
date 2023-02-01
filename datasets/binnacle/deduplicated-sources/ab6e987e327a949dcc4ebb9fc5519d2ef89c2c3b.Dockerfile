FROM debian:wheezy

ENV TERM=linux
ENV DEBIAN_FRONTEND noninteractive
ENV COMPOSER_ALLOW_SUPERUSER 1

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update \
    && apt-get install -y --no-install-recommends wget \
    && wget https://www.dotdeb.org/dotdeb.gpg --no-check-certificate \
    && apt-key add dotdeb.gpg \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 \
    && echo 'deb http://packages.dotdeb.org wheezy all' >> /etc/apt/sources.list \
    && echo 'deb-src http://packages.dotdeb.org wheezy all' >> /etc/apt/sources.list \
    && apt-get update && apt-get install -y --no-install-recommends curl ca-certificates nano \
    php5-cli php5-curl php5-json php5-mcrypt php5-mysql php5-xdebug php5-xsl php5-intl \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && apt-get -y --no-install-recommends install php5-fpm \
    && apt-get -y --no-install-recommends install procps git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Configure FPM to run properly on docker
RUN sed -i "/listen = .*/c\listen = 9000" /etc/php5/fpm/pool.d/www.conf \
    && sed -i "/;access.log = .*/c\access.log = /proc/self/fd/2" /etc/php5/fpm/pool.d/www.conf \
    && sed -i "/;clear_env = .*/c\clear_env = no" /etc/php5/fpm/pool.d/www.conf \
    && sed -i "/;catch_workers_output = .*/c\catch_workers_output = yes" /etc/php5/fpm/pool.d/www.conf \
    && sed -i "/pid = .*/c\;pid = /run/php/php5-fpm.pid" /etc/php5/fpm/php-fpm.conf \
    && sed -i "/;daemonize = .*/c\daemonize = no" /etc/php5/fpm/php-fpm.conf \
    && sed -i "/error_log = .*/c\error_log = /proc/self/fd/2" /etc/php5/fpm/php-fpm.conf \
    && usermod -u 1000 www-data

# The following runs FPM and removes all its extraneous log output on top of what your app outputs to stdout
CMD /usr/sbin/php5-fpm -F 2>&1 | sed -u 's,.*: \"\(.*\)$,\1,'| sed -u 's,"$,,' 1>&1

# Open up fcgi port
EXPOSE 9000

WORKDIR "/var/www/openskos"
