# Doc2.13-2.6.0kerfile
FROM openjdk:11-jre-slim
MAINTAINER  Author Name abhishekkr <abhikumar163@gmail.com>


ENV DEBIAN_FRONTEND noninteractive
ENV SCALA_VERSION 2.13
ENV KAFKA_VERSION 2.13-2.6.0
ENV KAFKA_PATCH_VERSION 2.6.0
ENV KAFKA_HOME /opt/kafka_"$KAFKA_VERSION"


RUN apt-get update && \
    mkdir -p /usr/share/man/man1 && \
    apt-get install --no-install-recommends -y wget supervisor dnsutils && \
    apt-get install --no-install-recommends -y default-jre && \
    apt-get install --no-install-recommends -y zookeeper && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# https://www.apache.org/dyn/closer.cgi?path=/kafka/2.6.0/kafka_2.13-2.6.0.tgz
RUN wget -q "https://apachemirror.wuchna.com/kafka/${KAFKA_PATCH_VERSION}/kafka_${KAFKA_VERSION}.tgz" -O /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz && \
    tar xfz /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -C /opt && \
    rm /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz

# Kafka start script
ADD scripts/start-kafka.sh /usr/bin/start-kafka.sh
RUN chmod +x /usr/bin/start-kafka.sh

# Supervisor config
ADD scripts/supervisor.kafka.conf scripts/supervisor.zk.conf /etc/supervisor/conf.d/

# 2181 is zookeeper, 9092 is kafka
EXPOSE 2181 9092

CMD ["supervisord", "-n"]
