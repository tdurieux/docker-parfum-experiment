FROM {{ "php73" | image_tag }}

USER root
RUN {{ "default-mysql-server" | apt_install }}

RUN {{ "
bzip2
unzip
zip
php7.3-intl
php7.3-mysql
curl
" | apt_install }}

COPY run-with-mysqld.sh /run-with-mysqld.sh
COPY run.sh /run.sh

RUN install --directory --owner nobody --group nogroup /var/run/mysqld/

USER nobody
ENTRYPOINT ["/run-with-mysqld.sh"]