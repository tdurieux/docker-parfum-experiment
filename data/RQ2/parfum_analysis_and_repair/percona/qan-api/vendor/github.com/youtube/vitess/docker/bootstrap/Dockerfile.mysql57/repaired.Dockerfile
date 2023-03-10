FROM vitess/bootstrap:common

# Install MySQL 5.7
RUN apt-key adv --recv-keys --keyserver ha.pool.sks-keyservers.net 5072E1F5 && \
    add-apt-repository 'deb http://repo.mysql.com/apt/debian/ stretch mysql-5.7' && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y mysql-server libmysqlclient-dev && \
    rm -rf /var/lib/apt/lists/*

# Bootstrap Vitess
WORKDIR /vt/src/github.com/youtube/vitess
USER vitess
# Required by e2e test dependencies e.g. test/environment.py.
ENV USER vitess
ENV MYSQL_FLAVOR MySQL56
RUN ./bootstrap.sh --skip_root_installs
