FROM adorsys/java:8

MAINTAINER https://github.com/adorsys/xs2a

ENV JAVA_OPTS -Xmx1024m -Dserver.port=8080
ENV JAVA_TOOL_OPTIONS -Xmx1024m

WORKDIR /opt/xs2a-starter

USER 0
RUN mkdir -p /opt/xs2a-starter/logs/ && chmod 777 /opt/xs2a-starter/logs/
USER 1001

COPY ./target/xs2a-standalone-starter-exec.jar /opt/xs2a-starter/xs2a-standalone-starter.jar

EXPOSE 8080

CMD exec $JAVA_HOME/bin/java $JAVA_OPTS -jar /opt/xs2a-starter/xs2a-standalone-starter.jar
