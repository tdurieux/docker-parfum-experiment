FROM debian:10-slim

RUN apt-get update && apt-get install --no-install-recommends -y default-jdk libmagickwand-dev imagemagick jmagick && rm -rf /var/lib/apt/lists/*;

ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java", "-Djmagick.systemclassloader=no", "-jar","/app.jar"]