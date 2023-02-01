FROM unicon/shibboleth-sp

RUN yum -y update \
    && yum -y install php mod_ssl && rm -rf /var/cache/yum

COPY etc-shibboleth /etc/shibboleth/
COPY etc-httpd/ /etc/httpd/
COPY var-www-html/ /var/www/html/
