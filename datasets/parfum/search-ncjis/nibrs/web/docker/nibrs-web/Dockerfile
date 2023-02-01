# Dockerfile for a Tomcat container that runs the nibrs validation app
# Note that you need to build the nibrs-web war file first, and copy into the bin directory before building or pushing to dockerhub

FROM ojbc/java8-server-base

MAINTAINER Open Justice Broker Consortium "http://www.ojbc.org"

WORKDIR /opt

COPY files/application.properties /opt/application.properties
COPY bin/nibrs-web.war /opt/nibrs-web.war

CMD ["java", "-jar", "nibrs-web.war"]
