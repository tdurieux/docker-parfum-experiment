FROM tomcat:8.0.45-jre8-alpine

ENV COLLECTOR_SERVER=127.0.0.1:12800

COPY catalina.sh /usr/local/tomcat/bin/
ADD spring-projectc /usr/local/tomcat/webapps/spring-projectc

ADD docker-entrypoint.sh /
RUN chmod +x /usr/local/tomcat/bin/catalina.sh && chmod +x /docker-entrypoint.sh

VOLUME /usr/local/tomcat/agent
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["catalina.sh", "run"]