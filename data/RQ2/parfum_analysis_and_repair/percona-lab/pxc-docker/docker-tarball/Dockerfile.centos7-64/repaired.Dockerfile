FROM centos:centos7
MAINTAINER Raghavendra Prabhu raghavendra.prabhu@percona.com
RUN curl -f -sL https://jenkins.percona.com/yum-repo/percona-dev.repo > /etc/yum.repos.d/percona-dev.repo
RUN yum install -y https://www.percona.com/downloads/percona-release/redhat/0.1-3/percona-release-0.1-3.noarch.rpm && rm -rf /var/cache/yum
RUN yum install -y which lsof libaio compat-readline5 socat percona-xtrabackup perl-DBD-MySQL perl-DBI rsync openssl098e eatmydata pv qpress gzip gdb hostname && rm -rf /var/cache/yum
ADD Percona-XtraDB-Cluster /pxc
RUN mkdir -p /pxc/datadir
ADD node.cnf /etc/my.cnf
ADD backtrace.gdb /backtrace.gdb
RUN groupadd -r mysql
RUN useradd -M -r -d /pxc/datadir -s /bin/bash -c "MySQL server" -g mysql mysql
EXPOSE 3306 4567 4568
RUN /pxc/scripts/mysql_install_db --basedir=/pxc --user=mysql
CMD  /pxc/bin/mysqld --basedir=/pxc --wsrep-new-cluster --user=mysql --core-file --skip-grant-tables --wsrep-sst-method=rsync
