# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

FROM oraclelinux:7-slim

RUN yum -y install oracle-php-release-el7 oracle-release-el7 && \
    yum -y install oracle-instantclient19.5-basic \
                   php-fpm \
                   php-json \
                   php-mbstring \
                   php-mysqlnd \
                   php-oci8-19c \
                   php-pdo \
                   php-soap \
                   php-xml && \
    rm -rf /var/cache/yum/* && \
    # Enable external access to PHP-FPM
    sed -i '/^listen = /clisten = 0.0.0.0:9000' /etc/php-fpm.d/www.conf && \
    sed -i '/^listen.allowed_clients/c;listen.allowed_clients =' /etc/php-fpm.d/www.conf && \
    # Redirect worker output to stdout for container logging
    sed -i '/^;catch_workers_output/ccatch_workers_output = yes' /etc/php-fpm.d/www.conf

EXPOSE 9000

WORKDIR /var/www

CMD ["/sbin/php-fpm", "-F", "-O"]