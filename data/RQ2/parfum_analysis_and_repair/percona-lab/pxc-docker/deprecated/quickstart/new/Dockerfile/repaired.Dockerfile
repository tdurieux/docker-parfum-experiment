FROM centos:centos7
MAINTAINER Raghavendra Prabhu raghavendra.prabhu@percona.com
RUN yum install -y http://www.percona.com/downloads/percona-release/redhat/0.1-3/percona-release-0.1-3.noarch.rpm && rm -rf /var/cache/yum
ADD node.cnf /etc/my.cnf
RUN yum install -y which && rm -rf /var/cache/yum
RUN yum install -y Percona-XtraDB-Cluster-56 && rm -rf /var/cache/yum
EXPOSE 3306 4567 4568
CMD /usr/sbin/mysqld --basedir=/usr --user=mysql --wsrep-new-cluster

