#
# forked from https://github.com/wurstmeister/kafka-docker
#

FROM anapsix/alpine-java

MAINTAINER Wurstmeister 

RUN apk add --update unzip wget curl docker jq coreutils

ENV KAFKA_VERSION="0.8.2.2" SCALA_VERSION="2.10"
ADD download-kafka.sh /tmp/download-kafka.sh
RUN /tmp/download-kafka.sh && tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt

VOLUME ["/kafka"]

ENV KAFKA_HOME /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}
ADD start-kafka.sh /usr/bin/start-kafka.sh
ADD broker-list.sh /usr/bin/broker-list.sh

# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)
CMD ["start-kafka.sh"]
