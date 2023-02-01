#Build stage
FROM maven:3.6.1-jdk-11 AS build-env

ADD . /rfc3161timestampingserver

WORKDIR rfc3161timestampingserver

RUN mvn -U compile package assembly:single

# Run it
FROM openjdk:11

COPY --from=build-env /rfc3161timestampingserver/target/*-jar-with-dependencies.jar /app/rfc3161timestampingserver.jar

EXPOSE 7000

CMD ["java", "-jar", "/app/rfc3161timestampingserver.jar"]