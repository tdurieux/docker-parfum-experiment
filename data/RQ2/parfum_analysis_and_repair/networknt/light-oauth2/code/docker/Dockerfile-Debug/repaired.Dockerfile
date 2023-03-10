FROM openjdk:11.0.3-slim
EXPOSE 5005
ADD /target/oauth2-code.jar server.jar
CMD ["/bin/sh","-c","java -agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005 -Dlight-4j-config-dir=/config -Dlogback.configurationFile=/config/logback.xml -Djava.security.krb5.conf=/config/krb5.conf -jar /server.jar"]