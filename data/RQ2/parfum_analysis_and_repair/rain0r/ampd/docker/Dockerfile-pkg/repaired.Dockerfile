FROM openjdk:11-jre-slim
WORKDIR /srv
COPY target/ampd-*SNAPSHOT.jar ./ampd.jar
EXPOSE 8080

CMD ["java", "-jar", "ampd.jar"]