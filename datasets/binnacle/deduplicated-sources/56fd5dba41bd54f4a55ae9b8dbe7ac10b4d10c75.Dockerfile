FROM vitess/bootstrap:common

# Install MySQL 5.6
RUN for i in $(seq 1 10); do apt-key adv --no-tty --recv-keys --keyserver pool.sks-keyservers.net 5072E1F5 && break; done && \
    add-apt-repository 'deb http://repo.mysql.com/apt/debian/ stretch mysql-5.6' && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server libmysqlclient-dev && \
    rm -rf /var/lib/apt/lists/*

# Bootstrap Vitess
WORKDIR /vt/src/vitess.io/vitess

ENV MYSQL_FLAVOR MySQL56
USER vitess
RUN ./bootstrap.sh
