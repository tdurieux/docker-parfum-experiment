FROM java:8

MAINTAINER Johannes Unterstein <junterstein@mesosphere.io>

ADD target/service-1.0-SNAPSHOT.jar /app.jar
EXPOSE 8080

CMD ["java", "-jar", "/app.jar"]