FROM openjdk:8-jre-alpine

EXPOSE 8080

RUN mkdir -p /maven/company/

COPY ./*-exec.jar  /maven/company/

ENTRYPOINT java $JAVA_OPTS -jar /maven/company/$ARTIFACT_ID-0.2.0-SNAPSHOT-exec.jar
