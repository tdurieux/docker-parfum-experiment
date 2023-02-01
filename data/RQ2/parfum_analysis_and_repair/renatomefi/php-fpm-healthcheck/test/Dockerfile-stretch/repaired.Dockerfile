FROM php:7.2-fpm-stretch

# Required software
RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends -y libfcgi-bin && rm -rf /var/lib/apt/lists/*;

# Enable php fpm status page
RUN set -xe && echo "pm.status_path = /status" >> /usr/local/etc/php-fpm.d/zz-docker.conf

COPY ./php-fpm-healthcheck /usr/local/bin/
