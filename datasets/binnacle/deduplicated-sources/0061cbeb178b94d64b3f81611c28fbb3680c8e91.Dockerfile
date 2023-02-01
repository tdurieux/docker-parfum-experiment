FROM anapsix/alpine-java:8_jdk_unlimited
MAINTAINER Venkata Ravuri <venkat@nikhu.com>

RUN apk add --update curl && \
    rm -rf /var/cache/apk/*

ADD ./build/libs/gateway-microservice-0.0.1-SNAPSHOT.jar /app/
CMD ["java", "-Xmx1024m", "-jar", "/app/gateway-microservice-0.0.1-SNAPSHOT.jar"]

EXPOSE 8000