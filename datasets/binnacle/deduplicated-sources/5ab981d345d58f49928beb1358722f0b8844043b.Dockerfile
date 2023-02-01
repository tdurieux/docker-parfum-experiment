FROM openjdk:8-jre-alpine
ADD zipkin-*.jar app.jar
EXPOSE 9411
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]