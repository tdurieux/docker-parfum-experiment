# Updated Dockerfile for IGRPWEB
# MAINTAINER: helpdesk@nosi.cv

# RUN MAVEN TO PACKAGE AND EXPORT WAR FILE

FROM maven:3.8.4-jdk-11-slim AS build

MAINTAINER helpdesk@nosi.cv

ENV HOME=/app

WORKDIR $HOME

COPY . $HOME/

RUN mvn clean package



#### RUN TOMCAT TO DEPLOY WAR FILE

FROM tomcat:8-jre8

RUN curl -SL https://repo.maven.apache.org/maven2/org/apache/tomee/apache-tomee/8.0.9/apache-tomee-8.0.9-plus.tar.gz -o tomee.tar.gz \
        && tar -xvf tomee.tar.gz --strip-components=1 \
        && rm bin/*.bat \
        && rm tomee.tar.gz*

ENV HOME=/app

EXPOSE 8080

ADD tomcat-users.xml /usr/local/tomcat/conf/

ADD context.xml /usr/local/tomcat/webapps/manager/META-INF/ 

ADD context.xml /usr/local/tomcat/conf/

#ADD index.jsp /usr/local/tomcat/webapps/ROOT/

COPY --from=build $HOME/IGRP-Template/target/*.war /usr/local/tomcat/webapps/

CMD ["catalina.sh", "run"]
