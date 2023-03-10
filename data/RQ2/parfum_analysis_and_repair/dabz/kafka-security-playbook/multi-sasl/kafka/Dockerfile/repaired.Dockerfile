FROM centos
MAINTAINER seknop@gmail.com
ENV container docker

# 1. Adding Confluent repository
RUN rpm --import https://packages.confluent.io/rpm/5.4/archive.key
COPY confluent.repo /etc/yum.repos.d/confluent.repo
RUN yum clean all

# 2. Install zookeeper and kafka
RUN yum install -y java-11-openjdk-devel && rm -rf /var/cache/yum
RUN yum install -y confluent-platform-2.12 && rm -rf /var/cache/yum

# 3. Configure Kafka and zookeeper for Kerberos
COPY server.properties /etc/kafka/server.properties
COPY kafka.sasl.jaas.config /etc/kafka/kafka_server_jaas.conf
COPY consumer.properties /etc/kafka/consumer.properties
COPY consumer.plain.properties /etc/kafka/consumer.plain.properties

EXPOSE 9093

CMD kafka-server-start /etc/kafka/server.properties
