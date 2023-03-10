FROM centos:centos7
MAINTAINER d.gasparina@gmail.com
ENV container docker

# 1. Adding Confluent repository
RUN rpm --import https://packages.confluent.io/rpm/5.4/archive.key
COPY confluent.repo /etc/yum.repos.d/confluent.repo
RUN yum clean all

# 2. Install confluent kafka tools:
RUN yum install -y java-11-openjdk && rm -rf /var/cache/yum
RUN yum install -y confluent-kafka-2.12 && rm -rf /var/cache/yum

# 3. Install Kerberos libaries
RUN yum install -y krb5-workstation krb5-libs && rm -rf /var/cache/yum

# 4. Copy in required settings for client access to Kafka
COPY consumer.properties /etc/kafka/consumer.properties
COPY producer.properties /etc/kafka/producer.properties
COPY command.properties /etc/kafka/command.properties
COPY client.sasl.jaas.config /etc/kafka/client_jaas.conf

ENV KAFKA_OPTS=-Djava.security.auth.login.config=/etc/kafka/kafka_server_jaas.conf

CMD sleep infinity
