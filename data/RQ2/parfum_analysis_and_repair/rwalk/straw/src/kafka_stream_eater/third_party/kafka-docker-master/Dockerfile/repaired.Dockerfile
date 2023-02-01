FROM ubuntu:trusty

MAINTAINER Wurstmeister

ENV KAFKA_VERSION="0.8.2.1" SCALA_VERSION="2.9.2"

RUN apt-get update && apt-get install --no-install-recommends -y unzip openjdk-6-jdk wget curl git docker.io jq && rm -rf /var/lib/apt/lists/*;

ADD download-kafka.sh /tmp/download-kafka.sh
RUN /tmp/download-kafka.sh
RUN tar xf /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt && rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz

VOLUME ["/kafka"]

ENV KAFKA_HOME /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}
ADD start-kafka.sh /usr/bin/start-kafka.sh
ADD broker-list.sh /usr/bin/broker-list.sh
CMD start-kafka.sh
