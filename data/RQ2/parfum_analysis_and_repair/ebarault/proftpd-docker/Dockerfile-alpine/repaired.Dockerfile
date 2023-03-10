FROM alpine:3.6
MAINTAINER "@ebarault"

RUN set -x && \
  apk update && \
  apk add --no-cache --virtual .persistent-deps \
    ca-certificates \
    curl \
    postgresql-client \
    gettext && \
  apk add --no-cache --virtual .build-deps \
    git \
    build-base \
    postgresql-dev

RUN git clone https://github.com/proftpd/proftpd.git && \
    git clone https://github.com/Castaglia/proftpd-mod_vroot.git

RUN cd proftpd-mod_vroot && \
    git checkout tags/v0.9.5 && \
    cd ..

RUN mv proftpd-mod_vroot proftpd/contrib/mod_vroot

RUN cd proftpd && \
  sed -i 's/__mempcpy/mempcpy/g' lib/pr_fnmatch.c && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --sysconfdir=/etc/proftpd --localstatedir=/var/proftpd --with-modules=mod_sql:mod_sql_postgres:mod_sql_passwd:mod_tls:mod_exec:mod_vroot --enable-openssl --disable-ident && \
  make && \
  make install && \
  cd ../ && \
  rm -rf proftpd && \
  apk del .build-deps

# man adduser: https://linux.die.net/man/1/busybox
RUN addgroup proftpd && \
  adduser -H -D -G proftpd proftpd

# CONF FILES
COPY proftpd.conf /etc/proftpd/proftpd.conf

# DEFAULT CONF FILES
COPY tls.conf /etc/proftpd/tls.conf
COPY sql.conf /etc/proftpd/sql.conf
COPY vroot.conf /etc/proftpd/vroot.conf
COPY ./certs /etc/proftpd/certs
COPY ./exec /etc/proftpd/exec

# SQL MIGRATION TEMPLATE
COPY sql/proftp_tables.sql.tpl /etc/proftpd/proftp_tables.sql.tpl

COPY entrypoint.sh ./entrypoint.sh
RUN chmod a+x ./entrypoint.sh

RUN mkdir /var/log/proftpd

# FTP ROOT
VOLUME /srv/ftp

EXPOSE 21 49152-49407

ENTRYPOINT ["./entrypoint.sh"]
