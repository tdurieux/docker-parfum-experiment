FROM maven:3.6-jdk-8-alpine AS builder
WORKDIR /tmp/src/
ADD . /tmp/src/
RUN mvn -Ddocker-build clean package


#FROM jetty:9.4-jre8
FROM orienteer/jetty:9.4-jdk8
USER root
COPY --from=builder /tmp/src/vuecket-demo/target/vuecket-demo-1.0-SNAPSHOT.war ${JETTY_BASE}/webapps/ROOT.war
USER jetty