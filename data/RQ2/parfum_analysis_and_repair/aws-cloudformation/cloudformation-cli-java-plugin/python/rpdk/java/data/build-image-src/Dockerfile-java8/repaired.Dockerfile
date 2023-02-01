FROM openjdk:8-alpine
ARG executable_name
ADD ${executable_name} handler.jar
ENTRYPOINT ["java", "-Xmx512M", "-cp", "handler.jar"]