# hdw-server-base docker配置
FROM frolvlad/alpine-oraclejdk8

MAINTAINER JacksonTu (tuminglong@126.com)

ENV PROJECT_HOME /home/project
ENV TOMCAT_HOME /home/tomcat/webapps
ENV OUTPUT_HOME /output
ENV JAVA_OPTS="-Xms256m -Xmx256m -Xss1m -Xmn128m"

RUN mkdir -p "$PROJECT_HOME" && mkdir -p "$OUTPUT_HOME" && mkdir -p "$TOMCAT_HOME"

ADD hdw-server-base.jar $PROJECT_HOME/hdw-server-base.jar

WORKDIR /home/project

# 指定容器内的时区
RUN echo "Asia/Shanghai" > /etc/timezone

ENTRYPOINT ["sh","-c","java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar $PROJECT_HOME/hdw-server-base.jar"]

EXPOSE 8181

# docker run -it -d --name hdw-server-base -p8181:8181 -v /output:/output -v /home/tomcat/webapps:/home/tomcat/webapps hdw-server-base:v1
