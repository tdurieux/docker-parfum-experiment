RUN mkdir -p /opt/bitnami/mysql/bin \
    && mkdir -p /opt/bitnami/mysql/sbin \
    && mkdir -p /opt/bitnami/mysql/lib \
    && mkdir -p /opt/bitnami/mysql/conf \
    && mkdir -p /opt/bitnami/mysql/share \
    && ln -sf /usr/bin/my*                          /opt/bitnami/mysql/bin/ \
    && ln -sf /usr/sbin/my*                         /opt/bitnami/mysql/sbin/ \
    && ln -sf /usr/sbin/my*                         /opt/bitnami/mysql/bin/ \
    && cp -rf /usr/lib64/mysql/plugin/               /opt/bitnami/mysql/lib/plugin/ \
    && cp -rf /usr/share/mysql-{{{VERSION_MAJOR_MINOR}}}/                    /opt/bitnami/mysql/share/mysql-{{{VERSION_MAJOR_MINOR}}}/ \
    && rm -rf /var/lib/dpkg/alternatives/my.cnf \
    && rm -rf /etc/mysql/my.cnf \
    && rm -rf /etc/mysql/mysql.cnf \
    && chown 1001:1001 -R /opt/bitnami/mysql /var/run/mysqld \
    && touch /opt/bitnami/mysql/conf/my.cnf \
    && ln -sf /opt/bitnami/mysql/conf/my.cnf /etc/mysql/my.cnf \
    && rm -f /opt/bitnami/mysql/conf/my.cnf