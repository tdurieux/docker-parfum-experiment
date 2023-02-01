FROM lizhenliang/java:8-jdk-alpine
LABEL maintainer www.ctnrs.com
ENV JAVA_ARGS="-Dfile.encoding=UTF8 -Duser.timezone=GMT+08"
COPY ./target/eureka-service.jar ./
COPY pinpoint /pinpoint
EXPOSE 8888
CMD java -jar -javaagent:/pinpoint/pinpoint-bootstrap-1.8.3.jar -Dpinpoint.agentId=${HOSTNAME} -Dpinpoint.applicationName=ms-eureka $JAVA_ARGS $JAVA_OPTS -Deureka.instance.hostname=${MY_POD_NAME}.eureka.ms /eureka-service.jar
