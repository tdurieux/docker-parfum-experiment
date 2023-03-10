ARG version
From mysql:$version

RUN apt-get update && apt-get -y --no-install-recommends install keepalived net-tools && rm -rf /var/lib/apt/lists/*;

ADD init.sh /init.sh
ADD chk_mysql.sh /chk_mysql.sh

ARG conf
ADD $conf/keepalive.conf /etc/keepalived/keepalived.conf

RUN chmod +x /init.sh
RUN chmod +x /chk_mysql.sh

ENTRYPOINT ["/init.sh"]

CMD ["mysqld"]
