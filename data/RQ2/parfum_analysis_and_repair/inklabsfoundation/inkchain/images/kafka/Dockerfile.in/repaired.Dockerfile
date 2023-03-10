# Copyright Greg Haskins All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
FROM _BASE_NS_/inkchain-baseimage:_BASE_TAG_

ENV SCALA_VERSION=2.11 \
#    KAFKA_VERSION=0.11.0.0
    KAFKA_VERSION=0.10.2.1
    KAFKA_DOWNLOAD_SHA256=b86f75c8f078bc818031568155dd442ba6c1ed849663d0a7da9870efc96be461

RUN curl -fsSL "https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" -o kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
    && echo "${KAFKA_DOWNLOAD_SHA256}  kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" | sha256sum -c - \
    && tar xfz kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -C /opt \
    && mv /opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION" /opt/kafka \
    && rm kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz

ADD payload/kafka-run-class.sh /opt/kafka/bin/kafka-run-class.sh

ADD payload/docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 9092
EXPOSE 9093

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/opt/kafka/bin/kafka-server-start.sh"]
