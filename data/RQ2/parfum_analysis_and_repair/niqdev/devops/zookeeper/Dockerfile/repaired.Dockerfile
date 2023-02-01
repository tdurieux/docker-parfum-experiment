FROM devops/base:latest
#FROM niqdev/phusion-base:latest

ARG VERSION=3.5.5

ENV ZOOKEEPER_HOME "/opt/zookeeper"
ENV PATH "$ZOOKEEPER_HOME/bin:$PATH"

RUN apt-get install --no-install-recommends -y \
  telnet \
  netcat && \
  apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN curl -f https://www-eu.apache.org/dist/zookeeper/zookeeper-${VERSION}/apache-zookeeper-${VERSION}-bin.tar.gz | tar -xzf - -C /opt && \
  mv /opt/apache-zookeeper-${VERSION}-bin /opt/zookeeper-${VERSION} && \
  ln -s /opt/zookeeper-${VERSION} /opt/zookeeper && \
  mkdir -p /var/log/zookeeper /var/lib/zookeeper/data

ADD zoo.cfg /opt/zookeeper/conf/zoo.cfg
ADD supervisor.ini /etc/supervisor/conf.d/zookeeper.conf
