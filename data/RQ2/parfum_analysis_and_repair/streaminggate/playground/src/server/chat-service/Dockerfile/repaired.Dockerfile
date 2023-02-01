FROM openjdk:11-jdk
RUN apt-get update && apt-get install --no-install-recommends -y iputils-ping && rm -rf /var/lib/apt/lists/*;
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-Dspring.profiles.active=develop", "-jar","/app.jar"]