# Copyright (c) 2020, 2022 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

FROM ghcr.io/oracle/oraclelinux:8

RUN dnf -y install oraclelinux-developer-release-el8 oracle-instantclient-release-el8 && \
    dnf -y module enable php:7.4 php-oci8:21c && \
    dnf -y install php-cli \
                   php-common \
                   php-fpm \
                   php-json \
                   php-mbstring \
                   php-mysqlnd \
                   php-pdo \
                   php-soap \
                   php-xml \
                   php-oci8-21c && \
    rm -rf /var/cache/dnf \
    && \
    # Enable external access to PHP-FPM
    mkdir -p /run/php-fpm && \
    sed -i '/^listen = /clisten = 0.0.0.0:9000' /etc/php-fpm.d/www.conf && \
    sed -i '/^listen.allowed_clients/c;listen.allowed_clients =' /etc/php-fpm.d/www.conf \
    && \
    # Redirect worker output to stdout for container logging
    sed -i '/^;catch_workers_output/ccatch_workers_output = yes' /etc/php-fpm.d/www.conf

EXPOSE 9000

WORKDIR /var/www

CMD ["/sbin/php-fpm", "-F", "-O"]
