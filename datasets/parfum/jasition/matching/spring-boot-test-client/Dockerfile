FROM openjdk:17-jdk-alpine3.13
EXPOSE 8081
ARG JAR_FILE=./build/libs/spring-boot-test-client-1.0.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]