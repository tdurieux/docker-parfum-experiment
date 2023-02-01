FROM frolvlad/alpine-java:jdk8-slim
MAINTAINER ThinkGem@163.com
ENV TZ "Asia/Shanghai"
ENV LANG C.UTF-8
VOLUME /tmp

WORKDIR /app
ADD web.war .
RUN jar -xvf web.war
# RUN chmod -R 755 ./*

WORKDIR /app/WEB-INF
# ENV JAVA_OPTS "-Xms256m -Xmx1024m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=512m"
ENV JAVA_OPTS "$JAVA_OPTS -Dspring.profiles.active=prod"

ADD bootstrap-prod.yml ./classes/config
# ADD jeesite.lic .

ENTRYPOINT java -cp /app $JAVA_OPTS org.springframework.boot.loader.WarLauncher

EXPOSE 8981

# docker run -p 8981:8981 com.jeesite/jeesite-cloud-module-core:4.1
