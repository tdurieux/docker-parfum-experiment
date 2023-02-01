FROM vitess/bootstrap:common

# Install MySQL 5.6
RUN for i in $(seq 1 10); do apt-key adv --no-tty --recv-keys --keyserver pool.sks-keyservers.net 5072E1F5 && break; done && \
    add-apt-repository 'deb http://repo.mysql.com/apt/debian/ stretch mysql-5.6' && \
    apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server libmysqlclient-dev libdbd-mysql-perl rsync libev4 && \
    rm -rf /var/lib/apt/lists/* && \
    wget https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.13/binary/debian/stretch/x86_64/percona-xtrabackup-24_2.4.13-1.stretch_amd64.deb && \
    dpkg -i percona-xtrabackup-24_2.4.13-1.stretch_amd64.deb && \
    rm -f percona-xtrabackup-24_2.4.13-1.stretch_amd64.deb

# Bootstrap Vitess
WORKDIR /vt/src/vitess.io/vitess

ENV MYSQL_FLAVOR MySQL56
USER vitess
RUN ./bootstrap.sh
