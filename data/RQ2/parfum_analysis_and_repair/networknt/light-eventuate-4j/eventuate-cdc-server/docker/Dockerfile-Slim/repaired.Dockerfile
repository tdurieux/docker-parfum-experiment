FROM openjdk:11.0.3-slim
ADD /target/eventuate-cdc-server.jar server.jar
CMD ["/bin/sh","-c","java -Dlight-4j-config-dir=/config -Dlogback.configurationFile=/config/logback.xml -jar /server.jar"]