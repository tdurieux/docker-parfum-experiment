FROM jboss/base-jdk:7

MAINTAINER http://openshift.io

USER root

ENV ZOOKEEPER_VERSION 3.4.6

EXPOSE 2181 2888 3888

RUN curl -f https://apache.mirrors.pair.com/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz | tar -xzf - -C /opt \
    && yum install -y gettext && yum clean all \
    && mv /opt/zookeeper-${ZOOKEEPER_VERSION} /opt/zookeeper \
    && cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg \
    && mkdir -p /opt/zookeeper/{data,log} && rm -rf /var/cache/yum

WORKDIR /opt/zookeeper
VOLUME ["/opt/zookeeper/conf", "/opt/zookeeper/data", "/opt/zookeeper/log"]

COPY config-and-run.sh ./bin/
COPY zoo-template.cfg ./conf/

CMD ["/opt/zookeeper/bin/config-and-run.sh"]
