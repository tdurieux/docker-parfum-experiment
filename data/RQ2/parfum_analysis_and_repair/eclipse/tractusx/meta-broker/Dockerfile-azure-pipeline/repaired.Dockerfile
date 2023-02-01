# Build maven
FROM maven:3.6.3-jdk-11-slim AS build

COPY . /home/app/

WORKDIR /home/app

ENV M2_HOME=/home/app/.m2
ENV MAVEN_OPTS="-Dmaven.repo.local=/home/app/.m2"

RUN mkdir -p $M2_HOME && mvn dependency:go-offline && mvn resources:resources

RUN mvn -f /home/app/pom.xml clean package

# Package in docker container