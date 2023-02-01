FROM openjdk:8-jdk-alpine
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} task1.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/task1.jar"]