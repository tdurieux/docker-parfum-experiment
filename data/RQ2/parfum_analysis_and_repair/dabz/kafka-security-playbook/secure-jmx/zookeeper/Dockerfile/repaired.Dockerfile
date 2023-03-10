FROM centos
MAINTAINER pere.urbon@gmail.com
ENV container docker

# 1. Adding Confluent repository
RUN rpm --import https://packages.confluent.io/rpm/5.5/archive.key
COPY confluent.repo /etc/yum.repos.d/confluent.repo
RUN yum clean all

# 2. Install zookeeper and kafka
RUN yum install -y java-11-openjdk && rm -rf /var/cache/yum
RUN yum install -y confluent-platform-2.12 && rm -rf /var/cache/yum

# 3. Configure Kafka and zookeeper for Kerberos
COPY zookeeper.properties /etc/kafka/zookeeper.properties

EXPOSE 2181
EXPOSE 9998

CMD zookeeper-server-start /etc/kafka/zookeeper.properties
