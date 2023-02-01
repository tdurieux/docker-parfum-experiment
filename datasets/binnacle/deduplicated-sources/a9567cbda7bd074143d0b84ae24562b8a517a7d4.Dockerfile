FROM frolvlad/alpine-oraclejdk8

MAINTAINER shalousun
EXPOSE 8080

# set timezone
RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone
#install Spring Boot artifact
VOLUME /tmp
ADD api-doc-test.jar app.jar
RUN sh -c 'touch /app.jar'
# set jvm
ENV JAVA_OPTS="-server -Xmx512m -Xms512m -Djava.awt.headless=true"
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar" ]