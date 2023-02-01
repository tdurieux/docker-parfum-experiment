FROM ubuntu:14.04

MAINTAINER boxkite

#Set users and environment variables
USER root
ENV CATALINA_HOME /usr/share/tomcat6
ENV CATALINA_BASE /var/lib/tomcat6

#Install the packages we need
RUN apt-get -q -y update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -q -y install solr-tomcat && rm -rf /var/lib/apt/lists/*;

EXPOSE 8080
CMD ["/usr/share/tomcat6/bin/catalina.sh", "run"]
