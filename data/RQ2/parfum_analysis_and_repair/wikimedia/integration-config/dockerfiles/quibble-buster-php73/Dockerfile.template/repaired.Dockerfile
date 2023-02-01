FROM {{ "sury-php" | image_tag }} AS sury-php

FROM {{ "quibble-buster" | image_tag }}

ENV PHP_VERSION=7.3

USER root

#############################
#  Debian packages we need  #
#############################
{% set mediawiki_deps|replace('\n', ' ') -%}
php7.3-apcu
php7.3-bcmath
php7.3-cli
php7.3-curl
php7.3-fpm
php7.3-gd
php7.3-gmp
php7.3-intl
php7.3-ldap
php7.3-mbstring
php7.3-memcached
php7.3-mysql
php7.3-pgsql
php7.3-sqlite3
php7.3-tidy
php7.3-xml
php7.3-zip
{%- endset -%}

# We need to get a newer version of php-ast from sury.org (T174338)
COPY --from=sury-php /etc/apt/trusted.gpg.d/php.gpg /etc/apt/trusted.gpg.d/php.gpg

RUN {{ "apt-transport-https" | apt_install }} && \
    echo "deb https://packages.sury.org/php/ buster main" > /etc/apt/sources.list.d/php.list

# Pin sury's repo higher for the packages that exist in both buster and sury
COPY sury.pin /etc/apt/preferences.d/sury
RUN {{ mediawiki_deps | apt_install }} \
    && /install-php-fpm-conf.sh

# Install XDebug but disables it by default due to its performance impact
RUN {{ "php7.3-xdebug" | apt_install }} \
    && phpdismod xdebug
# Same for pcov, although the performance overheade should be minimal
RUN {{ "php7.3-pcov" | apt_install }} \
    && phpdismod pcov

# Unprivileged
RUN install --directory /workspace --owner=nobody --group=nogroup
USER nobody
WORKDIR /workspace
ENTRYPOINT ["/usr/local/bin/quibble"]