FROM debezium/jdk8:8u92

MAINTAINER Debezium Community

#
# Set the version, home directory, and MD5 hash.
# MD5 hash from https://www.apache.org/dist/zookeeper/zookeeper-$ZK_VERSION/zookeeper-$ZK_VERSION.tar.gz.md5
#
ENV ZK_VERSION=3.4.8 \
    ZK_HOME=/zookeeper \
    MD5HASH=6bdddcd5179e9c259ef2bf4be2158d18

#
# Create a user and home directory for Zookeeper
#
USER root
RUN groupadd -r zookeeper -g 1001 && \
    useradd -u 1001 -r -g zookeeper -m -d $ZK_HOME -s /sbin/nologin -c "Zookeeper user" zookeeper && \
    chmod 755 $ZK_HOME

RUN mkdir $ZK_HOME/data && \
    mkdir $ZK_HOME/txns && \
    mkdir $ZK_HOME/logs

#
# Download and install Zookeeper
#
RUN curl -fSL -o /tmp/zookeeper.tar.gz $( curl -f --stderr /dev/null https://www.apache.org/dyn/closer.cgi\?as_json\=1 | sed -rn 's/.*"preferred":.*"(.*)"/\1/p')zookeeper/zookeeper-$ZK_VERSION/zookeeper-$ZK_VERSION.tar.gz

#
# Verify the contents and then install ...
#
RUN echo "$MD5HASH  /tmp/zookeeper.tar.gz" | md5sum -c - &&\
    tar -xzf /tmp/zookeeper.tar.gz -C $ZK_HOME --strip-components 1 &&\
    rm -f /tmp/zookeeper.tar.gz

# Set the working directory to the Zookeeper home directory
WORKDIR $ZK_HOME

#
# Customize the Zookeeper and Log4J configuration files
#
COPY ./zoo.cfg $ZK_HOME/conf/zoo.cfg
RUN sed -i -r -e "s|(\\$\\{zookeeper.log.dir\\})|$ZK_HOME/logs|g" \
              -e "s|(\\$\\{zookeeper.tracelog.dir\\})|$ZK_HOME/logs|g" \
              -e "s|(\\$\\{zookeeper.log.file\\})|zookeeper.log|g" \
              -e "s|(\\$\\{zookeeper.tracelog.file\\})|zookeeper_trace.log|g" \
              -e "s|(\[myid\:\%X\{myid\}\]\s?)||g" \
              -e 's|#(log4j.appender.ROLLINGFILE.MaxBackupIndex.*)|\1|g' \
              $ZK_HOME/conf/log4j.properties

#
# Change ownership and switch user
#
RUN chown -R zookeeper $ZK_HOME && \
    chgrp -R zookeeper $ZK_HOME
USER zookeeper

#
# Expose the ports and set up volumes for the data, transaction log, and configuration
#
EXPOSE 2181 2888 3888
VOLUME ["/zookeeper/data","/zookeeper/txns","/zookeeper/conf"]

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["start"]
