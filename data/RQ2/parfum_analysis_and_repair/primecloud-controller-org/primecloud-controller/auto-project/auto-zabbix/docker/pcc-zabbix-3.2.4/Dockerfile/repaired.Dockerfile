FROM centos:centos7

MAINTAINER PrimeCloud Controller/OSS Community

RUN sed -i -e "s/tsflags=nodocs/#tsflags=nodocs/g" /etc/yum.conf

# Install Apache HTTP Server
RUN yum install -y httpd && rm -rf /var/cache/yum

# Install MySQL
RUN yum install -y mariadb-server && rm -rf /var/cache/yum

COPY asset/server.cnf /etc/my.cnf.d/server.cnf
RUN chmod 644 /etc/my.cnf.d/server.cnf
RUN chown root:root /etc/my.cnf.d/server.cnf

# Install Zabbix
RUN yum install -y http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm && rm -rf /var/cache/yum
RUN yum install -y zabbix-server-mysql-3.2.4 zabbix-web-mysql-3.2.4 zabbix-web-japanese-3.2.4 && rm -rf /var/cache/yum

RUN localedef -f UTF-8 -i ja_JP ja_JP.utf8

RUN sed -i -e "/php_value date.timezone/c \        php_value date.timezone Asia\/Tokyo" /etc/httpd/conf.d/zabbix.conf

COPY asset/zabbix.conf.php /etc/zabbix/web/zabbix.conf.php
RUN chmod 644 /etc/zabbix/web/zabbix.conf.php
RUN chown apache:apache /etc/zabbix/web/zabbix.conf.php

# Entrypoint
COPY asset/entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

EXPOSE 80 3306
