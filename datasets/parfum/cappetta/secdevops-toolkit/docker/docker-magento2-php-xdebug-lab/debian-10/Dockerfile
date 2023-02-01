#FROM php:7.2-fpm
#FROM docker.io/bitnami/minideb:buster
FROM bitnami/php-fpm:7.3-debian-10-prod
MAINTAINER Simon Frost <s.frost@frostnet.co.uk>
MAINTAINER Cappetta <tcappetta@tenable.com>

ENV PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:/opt/bitnami/common/bin:/opt/bitnami/magento/bin:/opt/bitnami/common/bin:/opt/bitnami/nami/bin:$PATH"


COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates cron curl dirmngr gnupg libaudit1 libbsd0 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcurl4 libexpat1 libffi6 libfftw3-double3 libfontconfig1 libfreetype6 libgcc1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjemalloc2 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-6 libmagickwand-6.q16-6 libmcrypt4 libmemcached11 libmemcachedutil2 libncurses6 libnettle6 libnghttp2-14 libp11-kit0 libpam0g libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libunistring2 libuuid1 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxslt1.1 libzip4 procps sudo unzip zlib1g
RUN /build/bitnami-user.sh
RUN /build/install-nami.sh
RUN bitnami-pkg unpack apache-2.4.41-1 --checksum 2139963ce8e8fa949271b4ac7967b783b76a4aab87dfccb8a6f6715fc96a15d1
RUN bitnami-pkg unpack php-7.3.16-0 --checksum a22f5aeeb624440e1328c333916b949705665d3973e2922c4564183c16f9daab
RUN bitnami-pkg unpack mysql-client-10.2.31-1 --checksum 83278bc914a13a90a3ac05f43656f69dfbfc777e5b8672487a22a1ed65e3fda0
RUN bitnami-pkg install libphp-7.3.16-0 --checksum 54016628052dc5cfa73f7ca22874404effe184b768fb18fcc97000acac7e5080
RUN bitnami-pkg install tini-0.18.0-3 --checksum 1e9b72b6636c6a48397a18df2363b44461e87ad7f892c179a9115c7525ed9327
RUN bitnami-pkg unpack magento-2.3.4-1 --checksum 3160bb9222fc3ef21ed95204483ba18af6a6b8d8d989097cb9c14f38ccd06a08
RUN bitnami-pkg install gosu-1.11.0-3 --checksum c18bb8bcc95aa2494793ed5a506c4d03acc82c8c60ad061d5702e0b4048f0cb1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN sed -i -e '/pam_loginuid.so/ s/^#*/#/' /etc/pam.d/cron

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_ENABLE_CUSTOM_PORTS="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="magento" \
    BITNAMI_IMAGE_VERSION="2.3.4-debian-10-r43" \
    ELASTICSEARCH_HOST="" \
    ELASTICSEARCH_PORT_NUMBER="" \
    EXTERNAL_HTTPS_PORT_NUMBER="443" \
    EXTERNAL_HTTP_PORT_NUMBER="80" \
    MAGENTO_ADMINURI="admin" \
    MAGENTO_DATABASE_NAME="bitnami_magento" \
    MAGENTO_DATABASE_PASSWORD="" \
    MAGENTO_DATABASE_USER="bn_magento" \
    MAGENTO_EMAIL="user@example.com" \
    MAGENTO_FIRSTNAME="FirstName" \
    MAGENTO_HOST="127.0.0.1" \
    MAGENTO_LASTNAME="LastName" \
    MAGENTO_MODE="developer" \
    MAGENTO_PASSWORD="bitnami1" \
    MAGENTO_USERNAME="user" \
    MAGENTO_USE_SECURE_ADMIN="no" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    PHP_URL="https://www.php.net/get/php-7.3.16.tar.xz/from/this/mirror"


RUN apt-get update \
  && apt-get install -y \
    cron libfreetype6-dev libicu-dev libjpeg62-turbo-dev libmcrypt-dev \
    libxslt1-dev xz-utils autoconf build-essential gcc make autoconf \
    automake pkg-config zlib1g-dev curl \
  && apt-get autoremove

RUN curl -L https://github.com/docker-library/php/raw/master/docker-php-ext-configure -o /usr/local/bin/docker-php-ext-configure && \
    curl -L https://github.com/docker-library/php/raw/master/docker-php-ext-enable -o /usr/local/bin/docker-php-ext-enable && \
    curl -L https://github.com/docker-library/php/raw/master/docker-php-ext-install -o /usr/local/bin/docker-php-ext-install && \
    curl -L https://github.com/docker-library/php/raw/master/docker-php-source -o /usr/local/bin/docker-php-source && \
    chmod -R 755 /usr/local/bin/*  && \
    mkdir -p /usr/src && \
    curl -fsSL -o /usr/src/php.tar.xz "$PHP_URL"

ARG WITH_XDEBUG=false

RUN if [ $WITH_XDEBUG = "true" ] ; then \
        pecl install xdebug; \
        docker-php-ext-enable xdebug; \
    fi ;

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY mag.php.ini /opt/bitnami/php/conf/php.ini
COPY mag.php.ini /opt/bitnami/php/lib/php.ini

RUN find /opt/bitnami/magento/htdocs -type d -print0 | xargs -0 chmod 775 && find /opt/bitnami/magento/htdocs -type f -print0 | xargs -0 chmod 664 && chown -R bitnami:daemon /opt/bitnami/magento/htdocs

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]