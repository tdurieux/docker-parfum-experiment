FROM fabric8/java-jboss-openjdk8-jdk:1.4.0
ENV JAVA_APP_DIR=/deployments
EXPOSE 8080 8778 9779
COPY target/boot-demo-0.0.1.jar /deployments/
