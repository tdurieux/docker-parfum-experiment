# Written against Docker v1.5.0
FROM java:8
MAINTAINER Chris Rebert <code@rebertia.com>

WORKDIR /
USER daemon

ADD target/scala-2.11/rorschach-assembly-1.0.jar /app/server.jar

CMD ["java", "-jar", "/app/server.jar", "9090"]
EXPOSE 9090
