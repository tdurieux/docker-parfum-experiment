FROM debian:6
MAINTAINER Raghavendra Prabhu raghavendra.prabhu@percona.com
RUN apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A
RUN echo "deb http://repo.percona.com/apt squeeze main" >>  /etc/apt/sources.list
RUN echo "deb-src http://repo.percona.com/apt squeeze main" >> /etc/apt/sources.list
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -yq lsof libaio1 libreadline5 socat xtrabackup rsync libssl0.9.8 pv qpress gzip procps gdb && rm -rf /var/lib/apt/lists/*;
ADD Percona-XtraDB-Cluster /pxc
RUN mkdir -p /pxc/datadir
ADD node.cnf /etc/my.cnf
ADD backtrace.gdb /backtrace.gdb
RUN groupadd -r mysql
RUN useradd -M -r -d /pxc/datadir -s /bin/bash -c "MySQL server" -g mysql mysql
EXPOSE 3306 4567 4568
RUN /pxc/scripts/mysql_install_db --basedir=/pxc --user=mysql
CMD  /pxc/bin/mysqld --basedir=/pxc --wsrep-new-cluster --user=mysql --core-file --skip-grant-tables --wsrep-sst-method=rsync
