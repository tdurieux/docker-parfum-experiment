FROM fabric8/java-jboss-openjdk8-jdk

MAINTAINER Debezium Community

#
# Set the version, home directory, and MD5 hash.
# MD5 hash taken from http://kafka.apache.org/downloads.html for this version of Kafka
#
ENV KAFKA_VERSION=1.0.0 \
    SCALA_VERSION=2.11 \
    CONFLUENT_VERSION=4.0.0 \
    AVRO_VERSION=1.8.2 \
    AVRO_JACKSON_VERSION=1.9.13 \
    KAFKA_HOME=/kafka \
    SHA512HASH="b698028485d460c494af942b2dfa41c7342a2ad6052b543c95289cd1e832a1ebcf679b7e568dcabc342c799765337b94f91bc0cf0ee915534cdf82d1635a622a"
ENV KAFKA_URL_PATH=kafka/$KAFKA_VERSION/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz

#
# Create a user and home directory for Kafka
#
USER root
RUN yum -y install iproute && yum clean all && rm -rf /var/cache/yum
RUN groupadd -r kafka -g 1001 && useradd -u 1001 -r -g kafka -m -d $KAFKA_HOME -s /sbin/nologin -c "Kafka user" kafka && \
    chmod 755 $KAFKA_HOME
RUN mkdir $KAFKA_HOME/data && \
    mkdir $KAFKA_HOME/logs

#
# Change ownership and switch user
#
RUN chown -R kafka $KAFKA_HOME && \
    chgrp -R kafka $KAFKA_HOME

#
# Download Kafka
#
RUN curl -fSL -o /tmp/kafka.tgz $( curl -f --stderr /dev/null https://www.apache.org/dyn/closer.cgi\?as_json\=1 | sed -rn 's/.*"preferred":.*"(.*)"/\1/p')$KAFKA_URL_PATH || curl -fSL -o /tmp/kafka.tgz https://archive.apache.org/dist/$KAFKA_URL_PATH

#
# Verify the contents and then install ...
#
RUN echo "$SHA512HASH /tmp/kafka.tgz" | sha512sum -c - &&\
    tar -xzf /tmp/kafka.tgz -C $KAFKA_HOME --strip-components 1 &&\
    rm -f /tmp/kafka.tgz

COPY ./log4j.properties $KAFKA_HOME/config/log4j.properties
RUN mkdir $KAFKA_HOME/config.orig && mv $KAFKA_HOME/config/* $KAFKA_HOME/config.orig

# Remove unnecessary files
RUN rm $KAFKA_HOME/libs/*-{sources,javadoc,scaladoc}.jar* &&\
    rm -r $KAFKA_HOME/site-docs

#
# Allow random UID to use Kafka
#
RUN chmod -R g+w,o+w $KAFKA_HOME

USER kafka

# Set the working directory to the Kafka home directory
WORKDIR $KAFKA_HOME

#
# Expose the ports and set up volumes for the data and logs directories
#
EXPOSE 9092
VOLUME ["/kafka/data","/kafka/logs","/kafka/config"]

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["start"]
