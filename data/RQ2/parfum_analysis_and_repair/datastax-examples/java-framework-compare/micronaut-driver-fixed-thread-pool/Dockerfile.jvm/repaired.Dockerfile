FROM openjdk:11-jdk-slim
COPY target/micronaut-*.jar micronaut.jar
EXPOSE 8080
CMD java -Dcom.sun.management.jmxremote -noverify ${JAVA_OPTS} -jar micronaut.jar