RUN install_packages wget

ENV ZOOKEEPER_VERSION {{{VERSION}}}

RUN mkdir -p /opt/bitnami \
    && cd /opt/bitnami \
    && wget https://dlcdn.apache.org/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz \
    && wget https://downloads.apache.org/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz.sha512 \
    && cat apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz.sha512 | sha512sum --check - \
    && tar -xzf apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz \
    && mv apache-zookeeper-${ZOOKEEPER_VERSION}-bin/ zookeeper \
    && rm -rf apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz* \
    && chown 1001:1001 -R /opt/bitnami/zookeeper