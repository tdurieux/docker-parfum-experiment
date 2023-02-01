RUN install_packages php curl php-pear composer

RUN mkdir -p /opt/bitnami/php/bin \
    && mkdir -p /opt/bitnami/php/sbin \
    && mkdir -p /opt/bitnami/php/lib \
    && mkdir -p /opt/bitnami/php/etc \
    && ln -s /usr/bin/php*                           /opt/bitnami/php/bin/ \
    && ln -s /usr/bin/pear*                          /opt/bitnami/php/bin/ \
    && ln -s /usr/bin/phar*                          /opt/bitnami/php/bin/ \
    && ln -s /usr/bin/composer*                      /opt/bitnami/php/bin/ \
    && chown 1001:1001 -R /opt/bitnami/php

RUN cd /tmp \
 && curl -f -LO https://downloads.bitnami.com/files/stacksmith/php-{{{VERSION_ORIGINAL}}}-linux-amd64-{{{OS_FLAVOUR}}}.tar.gz \
 && tar -xzf php-{{{VERSION_ORIGINAL}}}-linux-amd64-{{{OS_FLAVOUR}}}.tar.gz -C /tmp --strip-components=1 \
 && cp -rf /tmp/files/php/etc/* /opt/bitnami/php/etc/ \
 && chown 1001:1001 -R /opt/bitnami/php \
 && rm -rf /tmp/* && rm php-{{{VERSION_ORIGINAL}}}-linux-amd64-{{{OS_FLAVOUR}}}.tar.gz
