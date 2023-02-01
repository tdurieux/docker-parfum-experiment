FROM landoop/fast-data-dev:latest
MAINTAINER Marios Andreopoulos <marios@landoop.com>

ARG ACTIVEMQ_VERSION="5.14.5"
RUN wget "http://apache.mirrors.ovh.net/ftp.apache.org/dist/activemq/${ACTIVEMQ_VERSION}/apache-activemq-${ACTIVEMQ_VERSION}-bin.tar.gz" \
            -O /activemq.tgz \
    && mkdir -p /opt/activemq \
    && tar -xzf /activemq.tgz --no-same-owner --strip-components=1 -C /opt/activemq \
    && rm -rf /activemq.tgz

RUN rm -rf /extra-connect-jars/* \
    && ln -s /opt/activemq/activemq-all-${ACTIVEMQ_VERSION}.jar /extra-connect-jars/activemq-all-${ACTIVEMQ_VERSION}.jar

RUN echo "retry.backoff.ms=500" >> /opt/confluent/etc/schema-registry/connect-avro-distributed.properties \
    && echo "task.shutdown.graceful.timeout.ms=15000" >> /opt/confluent/etc/schema-registry/connect-avro-distributed.properties \
    && echo "session.timeout.ms=60000" >> /opt/confluent/etc/schema-registry/connect-avro-distributed.properties \
    && echo "rebalance.timeout.ms=90000" >> /opt/confluent/etc/schema-registry/connect-avro-distributed.properties
#    && sed -e 's/INFO/DEBUG/' -i /opt/confluent/etc/schema-registry/log4j.properties /opt/confluent/etc/kafka/connect-log4j.properties
