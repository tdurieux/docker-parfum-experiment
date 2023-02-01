FROM google/debian:jessie

# Add all the image files to the root.
ADD infra/docker/db/files /

# TODO(skeswa): probably don't need to cleanup this early.
# Install Java 8 and clean up after.
RUN mv /java.list /etc/apt/sources.list.d/java.list \
  && apt-get update \
  && apt-get -qq -y install --no-install-recommends procps openjdk-8-jre-headless libjemalloc1 curl localepurge \
  && curl -L https://github.com/Yelp/dumb-init/releases/download/v1.0.3/dumb-init_1.0.3_amd64 > /dumb-init \
  && chmod a+rx /dumb-init \
  && apt-get -y purge localepurge curl \
  && apt-get clean \
  && rm -rf \
        doc \
        man \
        info \
        locale \
        /var/lib/apt/lists/* \
        /var/log/* \
        /var/cache/debconf/* \
        common-licenses \
        ~/.bashrc \
        /etc/systemd \
        /lib/lsb \
        /lib/udev \
        /usr/share/doc/ \
        /usr/share/doc-base/ \
        /usr/share/man/ \
        /tmp/*

# Configure env. before installing Cassandra.
ENV DEBUG true
ENV CASSANDRA_SERVICE db-svc
ENV CASSANDRA_CLUSTER_NAME gophr-cassandra-cluster
ENV CASSANDRA_AUTO_BOOTSTRAP false

# Install Cassandra and clean up after.
RUN mv /cassandra.list /etc/apt/sources.list.d/cassandra.list \
  && gpg --keyserver pgp.mit.edu --recv-keys F758CE318D77295D \
  && gpg --export --armor F758CE318D77295D | apt-key add - \
  && gpg --keyserver pgp.mit.edu --recv-keys 2B5C1B00 \
  && gpg --export --armor 2B5C1B00 | apt-key add - \
  && gpg --keyserver pgp.mit.edu --recv-keys 0353B12C \
  && gpg --export --armor 0353B12C | apt-key add - \
  && apt-get update \
  && apt-get -qq -y install --no-install-recommends curl cassandra localepurge \
  && chmod a+rx /run.sh /dumb-init /ready-probe.sh \
  && mkdir -p /cassandra_data/data \
  && mv /logback.xml /cassandra.yaml /etc/cassandra/ \
  && find /usr/share/cassandra/lib/sigar-bin -type f | grep -v libsigar-x86-linux.so | xargs rm \

  # Not able to run as cassandra until https://github.com/kubernetes/kubernetes/issues/2630 is resolved
  # && chown -R cassandra: /etc/cassandra /cassandra_data /run.sh /kubernetes-cassandra.jar \
  # && chmod o+w -R /etc/cassandra /cassandra_data \

  && apt-get -y purge curl localepurge \
  && apt-get clean \
  && rm -rf \
        doc \
        man \
        info \
        locale \
        /var/lib/apt/lists/* \
        /var/log/* \
        /var/cache/debconf/* \
        common-licenses \
        ~/.bashrc \
        /etc/systemd \
        /lib/lsb \
        /lib/udev \
        /usr/share/doc/ \
        /usr/share/doc-base/ \
        /usr/share/man/ \
        /tmp/*

# Install the Lucene plugin.
RUN mv /cassandra-lucene-plugin-3.7.1/* /usr/share/cassandra/lib/ \
  && rm -rf /cassandra-lucene-plugin-3.7.1

# https://issues.apache.org/jira/browse/CASSANDRA-11661
RUN sed -ri 's/^(JVM_PATCH_VERSION)=.*/\1=25/' /etc/cassandra/cassandra-env.sh

VOLUME ["/cassandra_data/data"]

# 7000: intra-node communication
# 7001: TLS intra-node communication
# 7199: JMX
# 9042: CQL
# 9160: thrift service not included cause it is going away
EXPOSE 7000 7001 7199 9042

# Not able to do this until https://github.com/kubernetes/kubernetes/issues/2630 is resolved
# if you are using attached storage
# USER cassandra

CMD ["/dumb-init", "/bin/bash", "/run.sh"]
