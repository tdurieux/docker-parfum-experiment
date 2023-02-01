FROM java:8
LABEL maintainer="info@javabydeveloper.com"
WORKDIR /myapp
COPY target/spring-boot-docker-example-0.0.1-SNAPSHOT.jar /myapp/my-app.jar
ENTRYPOINT ["java","-jar","my-app.jar"]