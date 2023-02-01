FROM tomcat:7.0.104-jdk8
MAINTAINER Emilio Martinez <emiliomartinez@guadaltel.com>

# Add certificate
ADD mapama.cer /tmp/mapama.cer
ADD idee.cer /tmp/idee.cer
ADD catastro.cer /tmp/catastro.cer
RUN echo yes | keytool -importcert -file /tmp/mapama.cer -keystore /usr/local/openjdk-8/jre/lib/security/cacerts -storepass changeit -alias "mapama"
RUN echo yes | keytool -importcert -file /tmp/idee.cer -keystore /usr/local/openjdk-8/jre/lib/security/cacerts -storepass changeit -alias "idee"
RUN echo yes | keytool -importcert -file /tmp/catastro.cer -keystore /usr/local/openjdk-8/jre/lib/security/cacerts -storepass changeit -alias "catastro"

ADD api-core.war $CATALINA_HOME/webapps/api-core.war

EXPOSE 8080