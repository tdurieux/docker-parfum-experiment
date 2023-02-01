FROM debian:stretch

ENV KAFKA_HOME /kafka
# The advertised host is kafka. This means it will not work if container is started locally and connected from localhost to it
ENV KAFKA_ADVERTISED_HOST kafka
ENV KAFKA_LOGS_DIR="/kafka-logs"
ENV KAFKA_VERSION 2.1.1
ENV _JAVA_OPTIONS "-Djava.net.preferIPv4Stack=true"
ENV TERM=linux

RUN apt-get update && apt-get install --no-install-recommends -y curl openjdk-8-jre-headless netcat && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p ${KAFKA_LOGS_DIR} && mkdir -p ${KAFKA_HOME} && curl -f -s -o $INSTALL_DIR/kafka.tgz \
    "https://mirror.easyname.ch/apache/kafka/${KAFKA_VERSION}/kafka_2.11-${KAFKA_VERSION}.tgz" && \
    tar xzf ${INSTALL_DIR}/kafka.tgz -C ${KAFKA_HOME} --strip-components 1 && rm ${INSTALL_DIR}/kafka.tgz

ADD run.sh /run.sh
ADD healthcheck.sh /healthcheck.sh

EXPOSE 9092
EXPOSE 2181

# Healthcheck creates an empty topic foo. As soon as a topic is created, it assumes broke is available
HEALTHCHECK --interval=1s --retries=600 CMD /healthcheck.sh

ENTRYPOINT ["/run.sh"]
