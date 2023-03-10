FROM centos:7

RUN yum -y install mariadb-server && \
    yum clean all && \
    \cp -f /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    /usr/sbin/adduser -u 2323 -g root telnetman && \
    echo telnetman:tcpport23 | chpasswd && \
    sed -i -e 's/\[mysqld\]/[mysqld]\nsocket=\/run\/mariadb\/mysql.sock\ncharacter-set-server = utf8\nskip-character-set-client-handshake\nmax_connect_errors=999999999\n\n[client]\nsocket=\/run\/mariadb\/mysql.sock\ndefault-character-set=utf8/' /etc/my.cnf.d/server.cnf && \
    chgrp -R 0   /run/mariadb && \
    chmod -R g=u /run/mariadb && \
    chgrp -R 0   /var/log/mariadb && \
    chmod -R g=u /var/log/mariadb && \
    chgrp -R 0   /var/lib/mysql && \
    chmod -R g=u /var/lib/mysql && rm -rf /var/cache/yum

ADD ./install/Telnetman2_Docker.sql /root/Telnetman2.sql
ADD ./install/start-db.sh /sbin/start.sh

EXPOSE 3306

USER telnetman

CMD ["sh", "/sbin/start.sh"]
