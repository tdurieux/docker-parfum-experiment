FROM openjdk:8-jdk-alpine

ENV COLLECTOR_SERVER=127.0.0.1:12800

ADD startup.sh /usr/local/skywalking-shardingsphere-scenario/
ADD shardingsphere-scenario.jar /usr/local/skywalking-shardingsphere-scenario/

ADD docker-entrypoint.sh /
RUN chmod +x /usr/local/skywalking-shardingsphere-scenario/startup.sh && chmod +x /docker-entrypoint.sh

EXPOSE 8080

VOLUME /usr/local/skywalking-shardingsphere-scenario/agent
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/local/skywalking-shardingsphere-scenario/startup.sh"]