# DOCKER-VERSION 1.12
FROM anapsix/alpine-java:jdk8
MAINTAINER Marco Spasiano <marco.spasiano@cnr.it>

RUN adduser -D -s /bin/sh jconon
WORKDIR /home/jconon
USER jconon

ADD cool-jconon-webapp/target/*.war /opt/jconon.war

EXPOSE 8080

# https://spring.io/guides/gs/spring-boot-docker/#_containerize_it