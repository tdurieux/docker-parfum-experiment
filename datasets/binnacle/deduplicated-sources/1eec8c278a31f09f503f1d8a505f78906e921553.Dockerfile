FROM java:openjdk-8-jre
MAINTAINER  Artem Malykh "Artem_Malykh@epam.com"

ENV SOLR_VERSION 5.5.4
ENV SOLR solr-$SOLR_VERSION
ENV SOLR_USER solr
ENV SOLR_STARTUP_PARAMS ""

# Install solr
RUN export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get -y install lsof && \
  groupadd -r $SOLR_USER && \
  useradd -r -g $SOLR_USER $SOLR_USER && \
  mkdir -p /opt && \
  wget -v --output-document=/opt/$SOLR.tgz http://www.us.apache.org/dist/lucene/solr/$SOLR_VERSION/$SOLR.tgz && \
  tar -C /opt --extract --file /opt/$SOLR.tgz && \
  rm /opt/$SOLR.tgz && \
  ln -s /opt/$SOLR /opt/solr

RUN mkdir /opt/solr/plugin && \
    mkdir /opt/solr/conf && \
    mkdir /opt/solr/server/solr/moldocs/lib -p && \
    mkdir /opt/solr/server/logs -p && \
    touch /opt/solr/server/logs/solr.log

COPY docker/scripts/indigo-lucene-startup.sh /opt/solr/startup.sh

RUN chmod +x /opt/solr/startup.sh

EXPOSE 8983

WORKDIR /opt/solr

EXPOSE 6900
#Port for remote profiling
EXPOSE 6901
#Port for remote profiling
EXPOSE 7900

RUN chown -R $SOLR_USER:$SOLR_USER /opt/solr /opt/$SOLR

RUN echo "$SOLR_USER:solr" | chpasswd && adduser $SOLR_USER sudo && \
    echo "$SOLR_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN printf "grant codebase \"file:/usr/lib/jvm/java-1.8.0-openjdk-amd64/lib/tools.jar\" {\n permission java.security.AllPermission;\n        };\n" > $JAVA_HOME/bin/jstatd.all.policy
RUN sed -i '/ENABLE_REMOTE_JMX_OPTS/d' /opt/solr/bin/solr.in.sh

ENV ENABLE_REMOTE_JMX_OPTS "true"
ENV RMI_PORT 6901
#ENV SOLR_STARTUP_PARAMS "-a \"-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=6900\""

USER $SOLR_USER
WORKDIR /opt/solr

RUN mkdir indigo-lucene
RUN chown -R $SOLR_USER indigo-lucene

VOLUME /opt/solr/indigo-lucene
VOLUME /opt/solr/server/solr/moldocs

CMD ["/bin/bash", "./startup.sh"]
