FROM adorsys/java:11
LABEL maintainer="https://github.com/adorsys/xs2a-connector-examples"

ENV SERVER_PORT 38080
ENV JAVA_OPTS -Xmx1024m
ENV JAVA_TOOL_OPTIONS -Xmx1024m

WORKDIR /opt/consent-management-server

COPY ./target/consents/consent-management-server.jar /opt/consent-management-server/consent-management-server.jar
COPY ./src/test/resources/consent-management-application.yml /opt/consent-management-server/consent-management-application.yml

EXPOSE 38080

CMD exec $JAVA_HOME/bin/java $JAVA_OPTS -jar /opt/consent-management-server/consent-management-server.jar