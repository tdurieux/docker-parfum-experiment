# Louis BAYLE, 2018-10-11
# Version 0.4

# 2018-10-11: update apache 2.4.25 fur security updates
# 2020-05-24: update to PHP v7.4
# 2021-11-11: do not include CodevTT: make it a volume for dev purpose

FROM centos:centos7
MAINTAINER Louis BAYLE <lbayle.work@gmail.com>

# ====================================================
# Container with Apache, PHP7, Mantis, CodevTT
# ====================================================
# https://hub.docker.com/r/lbayle/codevtt/

#note: You'll need one more container : centos/mariadb

# ====================================================
# build
# ====================================================
# docker build --rm -t codevtt:dev .

# docker exec -i  mariadb mysql -uroot -pmy_password --force bugtracker < mantis_codevtt_freshInstall.sql
# docker exec -it docker-codevtt-1 bash

# ====================================================
# docker-compose
# ====================================================

# docker exec -i docker-mariadb-1 mysql -uroot -pmy_password --force bugtracker < mantis_codevtt_freshInstall.sql

# ---------------------------------------------------------
#  mariadb:
#    image: centos/mariadb:latest
#    hostname: 'mariadb.fardeloup'
#    restart: unless-stopped
#    environment:
#      - MYSQL_ROOT_PASSWORD=my_password
#      - MYSQL_DATABASE=bugtracker
#      - MYSQL_USER=mantisbt
#      - MYSQL_PASSWORD=mantisbt
#    deploy:
#      resources:
#        limits:
#          memory: 1G
#
# ---------------------------------------------------------
#  codevtt:
#    image: codevtt:dev
#    hostname: 'codevtt.fardeloup'
#    restart: unless-stopped
#    ports:
#      - '80:80'
#    deploy:
#      resources:
#        limits:
#          memory: 1G
#    links:
#      - mariadb
#    volumes:
#      - /data/docker/codevtt/src:/var/www/html/codevtt
#      - /data/docker/codevtt/logs:/tmp/codevtt/logs
#      - /data/docker/codevtt/mantis/config:/var/www/html/mantis/config
#      - /data/docker/codevtt/mantis/plugins:/var/www/html/mantis/plugins
#      - /data/docker/codevtt/logs-httpd:/var/log/httpd/
#
#  # ---------------------------------------------------------
#  phpmyadmin:
#    image: phpmyadmin/phpmyadmin
#    restart: always
#    ports:
#      - 8080:80
#    environment:
#      - PMA_ARBITRARY=1
#      - PMA_HOST=mariadb
#      - PMA_USER=mantisbt
#      - PMA_PASSWORD=mantisbt
#    links:
#      - mariadb
#    volumes:
#      - /data/docker/phpmyadmin/config.user.inc.php:/etc/phpmyadmin/config.user.inc.php

# ====================================================

# Set ATOS proxy
#ENV http_proxy=http://193.56.47.8:8080
#ENV https_proxy=http://193.56.47.8:8080
#RUN sed -i '2iproxy=http:\/\/193.56.47.8:8080' /etc/yum.conf

# ------------------
# Add Epel & Remi repositories
RUN yum -y update && \
    yum -y install --setopt=tsflags=nodocs epel-release && \
    rpm -Uvh https://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum clean all && rm -rf /var/cache/yum

# ------------------
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 /etc/pki/rpm-gpg/RPM-GPG-KEY-remi /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

# ------------------
# Reinstall glibc-common for i18n.
# -> this fixes the case where only english is available in CodevTT
RUN yum -y --setopt=override_install_langs=all reinstall glibc-common && yum clean all

# ------------------
# install tools
RUN yum -y install \
        vim-enhanced \
        wget \
        git \
        git-gui \
        unzip \
        p7zip && \
    yum clean all && rm -rf /var/cache/yum

# ------------------
# install MySQL command-line client (for debug purpose)
#RUN yum -y --setopt=tsflags=nodocs install mariadb && yum clean all

# ------------------
# install Apache
RUN yum -y --setopt=tsflags=nodocs install \
        httpd \
        mod_ssl \
        openssl && \
    yum clean all

# Installing PHP 7.4
RUN yum -y --enablerepo=remi-php74 install \
        php-cli \
        php \
        php-fpm \
        php-common \
        php-mysqlnd \
        php-xml \
        php-adodb \
        php-curl \
        php-gd \
        php-mcrypt \
        php-ldap \
        php-imap \
        php-soap \
        php-mbstring \
        php-pecl-memcache \
        php-pecl-memcached \
        php-pecl-zip \
        php-pecl-xdebug \
        php-pear \
        php-pdo \
        php-bcmath \
        php-process \
        php-tidy \
        php-intl && \
    yum clean all && rm -rf /var/cache/yum

# ------------------

# set system timezone
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# set PHP timezone
RUN echo 'date.timezone=Europe/Paris' > /etc/php.d/00-docker-php-date-timezone.ini
#RUN sed -i "s/^;date.timezone =.*$/date.timezone = \"Europe\/Paris\"/" /etc/php.ini

# set PHP session lifetime (1 day)
RUN echo "session.gc_maxlifetime = 86400" > /etc/php.d/00-docker-php-session.ini

# ------------------
# install MantisBT

ENV MANTIS_VER 2.25.2
ENV MANTIS_URL https://downloads.sourceforge.net/project/mantisbt/mantis-stable/${MANTIS_VER}/mantisbt-${MANTIS_VER}.tar.gz
ENV MANTIS_FILE mantisbt-${MANTIS_VER}.tar.gz

RUN set -xe \
    && cd /var/www/html \
    && wget ${MANTIS_URL} \
    && tar -xvf ${MANTIS_FILE} \
    && rm ${MANTIS_FILE} \
    && mv mantisbt-${MANTIS_VER} mantis \
    && chown -R apache:apache mantis \
    && chmod -R g+w mantis

# ------------------
# install CodevTT

# no CodevTT install, we want a volume to a local install
# this is usefull for developping and/or pulling latest changes from gitlab

# add mantis plugin (in case you don't mount a volume for /var/www/html/mantis/plugins)
RUN set -xe \
    && cd /var/www/html/mantis/plugins \
    && ln -s /var/www/html/codevtt/mantis_plugin/mantis_2_0/CodevTT \
    && mkdir -p /var/www/html/codevtt \
    && mkdir -p /tmp/codevtt \
    && chown -R apache:apache /tmp/codevtt \
    && chown -R apache:apache /var/www/html/codevtt

# ------------------
# Update httpd.conf in order to restrict access as defined by .htaccess file.
# .htaccess files are not evaluated since a default apache install does not allow to override directives in /var/www
RUN set -xe \
    && echo "#Mantis specific access policy" > /etc/httpd/conf.d/mantis.conf \
    && echo "#CodevTT specific access policy" > /etc/httpd/conf.d/codevtt.conf \
    && for f in $(find /var/www/html/mantis -name .htaccess) ; do \
    echo "<Directory $(dirname $f)>" >> /etc/httpd/conf.d/mantis.conf \
    && cat $f >> /etc/httpd/conf.d/mantis.conf \
    && echo -e "\n</Directory>\n" >> /etc/httpd/conf.d/mantis.conf \
    ; done \
    && for f in $(find /var/www/html/codevtt -name .htaccess) ; do \
    echo "<Directory $(dirname $f)>" >> /etc/httpd/conf.d/codevtt.conf \
    && cat $f >> /etc/httpd/conf.d/codevtt.conf \
    && echo -e "\n</Directory>\n" >> /etc/httpd/conf.d/codevtt.conf \
    ; done

# ------------------
# Adding config files (bugtracker)
ADD httpd_config/ssl.conf                      /etc/httpd/conf.d/ssl.conf
ADD httpd_config/php.ini                       /etc
ADD mantis_config/config_inc.php               /var/www/html/mantis/config
ADD mantis_config/custom_constants_inc.php     /var/www/html/mantis/config
ADD mantis_config/custom_relationships_inc.php /var/www/html/mantis/config
ADD mantis_config/custom_strings_inc.php       /var/www/html/mantis/config
ADD codevtt_config/config.ini                  /var/www/html/codevtt/config
ADD codevtt_config/log4php.xml                 /var/www/html/codevtt
ADD index.html                                 /var/www/html/index.html

# ------------------

EXPOSE 80
ENTRYPOINT ["/usr/sbin/httpd"]
CMD ["-D", "FOREGROUND"]
