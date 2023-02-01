FROM oraclelinux:latest

MAINTAINER Mark Leith (mark@markleith.co.uk)

RUN yum install -y https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.5/mysql-cluster-community-data-node-7.5.4-1.el7.x86_64.rpm

RUN mkdir -p /var/lib/ndb/data

EXPOSE 11860

ADD run.sh /home/mysql/run-data.sh
RUN chmod +x /home/mysql/run-data.sh
ENTRYPOINT ["/home/mysql/run-data.sh"]
