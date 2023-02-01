ARG TOMCAT_TAG

FROM tomcat:${TOMCAT_TAG:-8}

RUN apt-get update && \
    apt-get -y install coreutils file jq netcat xmlstarlet

RUN mkdir -p /usr/local/tomcat/webapps/rundeck/rundeck/server/config \
    && mkdir -p /usr/local/tomcat/webapps/rundeck/rundeck/var/log


COPY rundeck-config.properties /usr/local/tomcat/webapps/rundeck/rundeck/server/config

COPY data/rundeck-launcher.war /usr/local/tomcat/webapps/rundeck.war

RUN cd /usr/local/tomcat/webapps/rundeck && unzip ../rundeck.war

COPY entry.sh /root

COPY server.xml /usr/local/tomcat/conf/server.xml

# Copy files.
RUN mkdir -p /scripts
COPY scripts /scripts
RUN chmod -R a+x /scripts/*

COPY api_test /api_test

# RUN mkdir -p /tests
# COPY tests /tests
# RUN chmod -R a+x /tests/*

ENTRYPOINT [ "/root/entry.sh" ]