FROM centos:centos8
MAINTAINER d.gasparina@gmail.com
ENV container docker

# 1. Adding Confluent repository
RUN rpm --import https://packages.confluent.io/rpm/5.4/archive.key
COPY confluent.repo /etc/yum.repos.d/confluent.repo
RUN yum clean all

# 2. Install zookeeper and kafka
RUN yum install -y java-1.8.0-openjdk && rm -rf /var/cache/yum
RUN yum install -y confluent-platform-2.12 && rm -rf /var/cache/yum
#schema-registry package is rquiterd to run kafka-avro-console-producer
RUN yum install -y confluent-schema-registry && rm -rf /var/cache/yum

# 3. Configure Kafka
COPY server.properties /etc/kafka/server.properties
COPY consumer.properties /etc/kafka/consumer.properties

EXPOSE 9093

CMD kafka-server-start /etc/kafka/server.properties
