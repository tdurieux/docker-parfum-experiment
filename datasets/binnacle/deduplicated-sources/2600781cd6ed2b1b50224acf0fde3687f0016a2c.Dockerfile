FROM maven:3.6-jdk-8 AS buildertomcat

COPY pom.xml /app/
COPY src /app/src/

WORKDIR /app
RUN mvn --batch-mode --define java.net.useSystemProxies=true package

########################################################################################

FROM tomcat:9.0-jre8-slim
MAINTAINER D.Ducatel

RUN apt-get update && \
    apt-get install -y --no-install-recommends graphviz fonts-noto-cjk && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV GRAPHVIZ_DOT=/usr/bin/dot

ARG BASE_URL=ROOT
RUN rm -rf /usr/local/tomcat/webapps/$BASE_URL
COPY --from=buildertomcat /app/target/plantuml.war /usr/local/tomcat/webapps/$BASE_URL.war
