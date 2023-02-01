FROM ubuntu:latest

MAINTAINER Dapeng "dapeng@edgenius.com"

# Update Ubuntu
RUN apt-get update && apt-get -y upgrade

# Add oracle java 8 repository
RUN apt-get -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get -y update

# Install Oracle Java
# Accept the Oracle Java license
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 boolean true" | debconf-set-selections
RUN apt-get -y --no-install-recommends install oracle-java8-installer && rm -rf /var/lib/apt/lists/*;

# Install tomcat
RUN apt-get -y --no-install-recommends install tomcat8 && rm -rf /var/lib/apt/lists/*;

COPY logging.properties /etc/tomcat8
COPY tomcat8.sh /tomcat8/
RUN chmod +x /tomcat8/tomcat8.sh

RUN rm -rf /var/lib/tomcat8/webapps/ROOT/*

COPY geniuswiki.war /var/lib/tomcat8/webapps/ROOT/
RUN cd /var/lib/tomcat8/webapps/ROOT/ && jar xvf geniuswiki.war && rm geniuswiki.war

WORKDIR /tomcat8/
CMD /bin/bash -c ./tomcat8.sh