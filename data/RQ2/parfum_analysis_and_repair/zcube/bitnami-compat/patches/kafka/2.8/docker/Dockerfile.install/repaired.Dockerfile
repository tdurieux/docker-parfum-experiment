RUN install_packages wget

ENV SCALA_VERSION 2.13
ENV KAFKA_VERSION {{{VERSION}}}

    # && cat kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz.sha512 | sha512sum --check - \
RUN mkdir -p /opt/bitnami \
    && cd /opt/bitnami \
    && wget https://dlcdn.apache.org/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
    && wget https://downloads.apache.org/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz.sha512 \
    && tar -xzf kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
    && mv kafka_${SCALA_VERSION}-${KAFKA_VERSION}/ kafka \
    && rm -rf kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz* \
    && chown 1001:1001 -R /opt/bitnami/kafka