FROM ubuntu:16.04 AS base

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV KM_VERSION=1.2.7

RUN apt-get update && apt-get install --no-install-recommends -y \
    python3 \
    python3-pip \
    python3-wheel \
    openjdk-8-jdk \
    wget \
    supervisor && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir tensorflow numpy kafka-python

ADD . /code

WORKDIR /code

RUN wget https://www-us.apache.org/dist/kafka/2.0.0/kafka_2.11-2.0.0.tgz

RUN tar -xvzf kafka_2.11-2.0.0.tgz && rm kafka_2.11-2.0.0.tgz

RUN cp server.properties kafka_2.11-2.0.0/config/

RUN echo
