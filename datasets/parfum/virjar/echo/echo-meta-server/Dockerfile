FROM docker.io/java:openjdk-8u111-jre-alpine
WORKDIR /app
COPY ./target/echo-meta-server-0.0.1.jar .
RUN ls
CMD ["java", "-jar", "/app/echo-meta-server-0.0.1.jar","--server.port","8080"]