FROM alpine:3.10

RUN \
  apk --update --no-cache add autoconf pgbouncer autoconf-doc automake udns udns-dev curl gcc libc-dev libevent libevent-dev libtool make man libressl-dev pkgconfig postgresql-client && \
  mkdir -p /etc/pgbouncer && \
  mkdir -p /var/run/postgresql && \
  mkdir -p /var/log/postgresql && \
  chown -R postgres:postgres /var/run/postgresql && \
  touch /var/log/postgresql/pgbouncer.log && \
  chmod u+rwx /var/log/postgresql/pgbouncer.log && \
  chown -R postgres:postgres /var/log/postgresql && \
  chown -R postgres:postgres /etc/pgbouncer && \
  apk del --purge autoconf autoconf-doc automake udns-dev curl gcc libc-dev libevent-dev libtool make man libressl-dev pkgconfig
USER postgres
EXPOSE 6433

COPY env/docker/conf/pgbouncer/pgbouncer.ini /etc/pgbouncer/pgbouncer.ini
COPY env/docker/conf/pgbouncer/userlist.txt /etc/pgbouncer/userlist.txt

CMD ["/usr/bin/pgbouncer", "/etc/pgbouncer/pgbouncer.ini"]
