FROM adorsys/java:11
LABEL maintainer="https://github.com/adorsys/xs2a-connector-examples"

ENV SERVER_PORT 8090
ENV JAVA_OPTS -Xmx1024m
ENV JAVA_TOOL_OPTIONS -Xmx1024m

WORKDIR /opt/xs2a-connector-examples

USER 0
RUN mkdir -p /opt/xs2a-connector-examples/logs/ && chmod 777 /opt/xs2a-connector-examples/logs/
USER 1001

COPY ./target/online-banking-app.jar /opt/xs2a-connector-examples/xs2a-online-banking.jar

EXPOSE 8090
# hadolint ignore=DL3025
CMD exec $JAVA_HOME/bin/java $JAVA_OPTS -jar /opt/xs2a-connector-examples/xs2a-online-banking.jar
