FROM openjdk:8-jre-alpine
ADD api-*.jar app.jar
EXPOSE 8002
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]