FROM java:8-jre-alpine
MAINTAINER Bin Wu <bin.wu@ptengine.com>

ARG MIRROR=http://apache.mirrors.pair.com
ARG VERSION=3.4.9

LABEL name="zookeeper" version=$VERSION

RUN apk add --no-cache wget bash \
  && mkdir /opt \
  && wget -q -O - $MIRROR/zookeeper/zookeeper-$VERSION/zookeeper-$VERSION.tar.gz | tar -xzf - -C /opt \
  && mv /opt/zookeeper-$VERSION /opt/zookeeper \
  && cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg
#&& mkdir -p /tmp/zookeeper

EXPOSE 2181 2888 3888

WORKDIR /opt/zookeeper

RUN mkdir -p /opt/zookeeper/logs
ENV ZOO_LOG_DIR /opt/zookeeper/logs
ENV ZOO_LOG4J_PROP INFO,ROLLINGFILE

#VOLUME ["/opt/zookeeper/conf", "/tmp/zookeeper"]

ENTRYPOINT ["/opt/zookeeper/bin/zkServer.sh"]
CMD ["start-foreground"]