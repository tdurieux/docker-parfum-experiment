FROM centos:centos7

RUN yum -y update \
    && yum -y install httpd mod_ssl mod_ldap \
    && yum -y clean all && rm -rf /var/cache/yum

COPY httpd-foreground /usr/local/bin/
COPY etc-httpd/ /etc/httpd/
COPY var-www-html/ /var/www/html/

EXPOSE 80 443

CMD ["httpd-foreground"]