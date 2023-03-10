FROM openjdk:8-jdk-alpine
# best practice is not to use root user
RUN adduser -D demo 
USER demo
ADD target/csstore-microservice-*.jar app.jar
ENTRYPOINT ["java","-jar","app.jar"]