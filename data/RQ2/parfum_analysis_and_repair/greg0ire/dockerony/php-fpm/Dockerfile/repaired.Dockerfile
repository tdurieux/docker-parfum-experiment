FROM greg0ire/php:latest

ENV DEBIAN_FRONTEND noninteractive

# Install packages that are specific to our stack
RUN apt-get update && \
    apt-get install --no-install-recommends --yes \
    php7.0-fpm && \
    rm --recursive --force /var/lib/apt/lists/*

# Sanctify (the opposite of daemonize :D ) php-fpm
RUN sed -i -e 's/;daemonize\s*=\s*yes/daemonize = no/g' /etc/php/7.0/fpm/php-fpm.conf

ADD www.conf /etc/php/7.0/fpm/pool.d/www.conf
ADD php-fpm.ini /etc/php/7.0/fpm/php.ini

COPY entrypoint.sh /

RUN chmod u+x /entrypoint.sh
RUN mkdir /run/php

EXPOSE 9000
ENTRYPOINT ["/entrypoint.sh"]

CMD ["php-fpm7.0", "--nodaemonize"]
