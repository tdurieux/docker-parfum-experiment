FROM java:8-jre
MAINTAINER Taroco liuht <liuht777@qq.com>

ADD ./jar/taroco-service-governance-*.jar /app/app.jar

EXPOSE 9002

ENV JAVA_OPTS="-Xmx256m -Xms256m"
ENV CONFIG_PROFILE=show

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS \
-Dfile.encoding=UTF8 -Duser.timezone=GMT+08 \
-Djava.security.egd=file:/dev/./urandom \
-Dspring.profiles.active=$CONFIG_PROFILE \
-jar /app/app.jar"]
