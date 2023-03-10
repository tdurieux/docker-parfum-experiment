FROM {{ "tox" | image_tag }}

USER root
RUN {{ "mysql-server percona-toolkit" | apt_install }}

COPY run-with-mysqld.sh /run-with-mysqld.sh
USER nobody
ENTRYPOINT ["/run-with-mysqld.sh"]