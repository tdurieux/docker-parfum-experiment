FROM openjdk:11-jdk-slim
COPY target/helidon-mp.jar helidon-mp.jar
COPY target/libs libs
EXPOSE 8080
CMD ["java", "-jar", "helidon-mp.jar"]