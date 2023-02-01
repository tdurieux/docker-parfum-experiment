FROM ubuntu:16.04

ENV JMX_PORT=7099
EXPOSE 7099

RUN apt-get update
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y default-jre && rm -rf /var/lib/apt/lists/*;

ARG KAFKA_VERSION=1.0.1
ENV KAFKA_VERSION=$KAFKA_VERSION
ENV KAFKA_BIN="/opt/kafka_2.11-$KAFKA_VERSION/bin"

RUN cd /opt/ && wget https://archive.apache.org/dist/kafka/"$KAFKA_VERSION"/kafka_2.11-"$KAFKA_VERSION".tgz && \
    tar -zxf kafka_2.11-"$KAFKA_VERSION".tgz && cd kafka_2.11-"$KAFKA_VERSION"/ && rm kafka_2.11-"$KAFKA_VERSION".tgz
ADD scripts/* scripts/
CMD ["bash", "scripts/run.sh"]
