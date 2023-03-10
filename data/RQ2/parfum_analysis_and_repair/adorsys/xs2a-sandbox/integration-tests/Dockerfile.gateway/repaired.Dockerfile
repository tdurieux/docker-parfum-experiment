FROM adorsys/java:11
LABEL maintainer="https://github.com/adorsys/xs2a-connector-examples"

ENV SERVER_PORT 8089
ENV JAVA_OPTS -Xmx1024m
ENV JAVA_TOOL_OPTIONS -Xmx1024m

WORKDIR /opt/gateway-app

COPY ./target/gateway/gateway-app.jar /opt/gateway-app/gateway-app.jar

EXPOSE 8089

CMD exec $JAVA_HOME/bin/java $JAVA_OPTS -jar /opt/gateway-app/gateway-app.jar