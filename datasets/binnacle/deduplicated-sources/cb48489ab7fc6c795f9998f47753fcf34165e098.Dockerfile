FROM anapsix/alpine-java

MAINTAINER Mossaddeque Mahmood

VOLUME /tmp
ADD target/openblog.jar app.jar
ENV JAVA_OPTS="-Dspring.profiles.active=dev,mysql"
ENTRYPOINT exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar
