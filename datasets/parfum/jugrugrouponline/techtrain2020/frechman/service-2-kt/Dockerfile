FROM openjdk:8-jdk-alpine
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} app2-kt.jar
EXPOSE 8082
ENTRYPOINT ["java","-jar","/app2-kt.jar"]