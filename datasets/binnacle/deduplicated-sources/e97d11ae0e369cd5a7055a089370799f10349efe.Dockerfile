# Replacing standard java-8 Docker image with a 32 bit, embedded jre 8 version, reduces the memory consumption with some 50%
# FROM java:8
FROM ofayau/ejre:8-jre
MAINTAINER Magnus Larsson <magnus.larsson.ml@gmail.com>

EXPOSE 8765

ADD ./build/libs/*.jar app.jar
ADD src/main/resources/truststore.jks truststore.jks

# Regarding settings of java.security.egd, see http://wiki.apache.org/tomcat/HowTo/FasterStartUp#Entropy_Source
ENTRYPOINT ["java","-Dspring.profiles.active=docker","-Djavax.net.ssl.trustStore=truststore.jks","-Djavax.net.ssl.trustStorePassword=password","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
