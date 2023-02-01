FROM openjdk:17-jdk-alpine3.13
EXPOSE 8080
EXPOSE 8850
EXPOSE 8860
ARG JAR_FILE=./build/libs/spring-boot-app-1.0.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]