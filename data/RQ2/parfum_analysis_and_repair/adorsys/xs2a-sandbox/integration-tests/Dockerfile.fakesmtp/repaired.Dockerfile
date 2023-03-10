FROM adorsys/java:11
LABEL maintainer="https://github.com/adorsys/xs2a-connector-examples"

ENV SERVER_PORT 2500
ENV JAVA_OPTS -Xmx512m
ENV JAVA_TOOL_OPTIONS -Xmx512m

WORKDIR /opt/fakesmtp

COPY ./target/fakesmtp/fakesmtp.jar /opt/fakesmtp/fakesmtp.jar

EXPOSE 2500

CMD exec $JAVA_HOME/bin/java $JAVA_OPTS -jar /opt/fakesmtp/fakesmtp.jar -s -b -p 2500 -o /var/lib/data/fakesmtp/mails