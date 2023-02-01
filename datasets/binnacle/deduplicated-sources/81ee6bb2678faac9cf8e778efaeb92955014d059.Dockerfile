FROM vitess/bootstrap:common

# Install MariaDB 10
RUN apt-get update -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      bzip2 \
      mariadb-server \
      libmariadbclient-dev \
      libdbd-mysql-perl \
      rsync \
      libev4 \
 && rm -rf /var/lib/apt/lists/* \
 && wget https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.13/binary/debian/stretch/x86_64/percona-xtrabackup-24_2.4.13-1.stretch_amd64.deb \
 && dpkg -i percona-xtrabackup-24_2.4.13-1.stretch_amd64.deb \
 && rm -f percona-xtrabackup-24_2.4.13-1.stretch_amd64.deb

# Bootstrap Vitess
WORKDIR /vt/src/vitess.io/vitess

ENV MYSQL_FLAVOR MariaDB
USER vitess
RUN ./bootstrap.sh
