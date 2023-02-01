FROM lizhenliang/java:8-jdk-alpine
LABEL maintainer www.ctnrs.com
ENV JAVA_ARGS="-Dfile.encoding=UTF8 -Duser.timezone=GMT+08"
COPY ./target/portal-service.jar ./
COPY pinpoint /pinpoint
EXPOSE 8080
CMD java -jar -javaagent:/pinpoint/pinpoint-bootstrap-1.8.3.jar -Dpinpoint.agentId=$(echo $HOSTNAME | awk -F- '{print "portal-"$NF}') -Dpinpoint.applicationName=ms-portal $JAVA_ARGS $JAVA_OPTS /portal-service.jar
