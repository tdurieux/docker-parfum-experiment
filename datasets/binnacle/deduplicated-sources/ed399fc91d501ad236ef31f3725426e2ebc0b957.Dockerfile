# Copyright (C) 2012-2017 Thales Services SAS.
#
# This file is part of AuthZForce CE.
#
# AuthZForce CE is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# AuthZForce CE is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with AuthZForce CE.  If not, see <http://www.gnu.org/licenses/>.

# Best practices for writing Dockerfiles:
# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/

# Tips to do an unattended installation on Debian/Ubuntu: 
# http://www.microhowto.info/howto/perform_an_unattended_installation_of_a_debian_package.html

# The alternative is to use FROM ubuntu:* then install tomcat ubuntu package and use upstart/sysctl init script but this is not the way to go:
# https://github.com/docker/docker/issues/6800
FROM tomcat:8-jre8
MAINTAINER AuthzForce Team (contact mailing list: http://scr.im/azteam)

ENV DEBIAN_FRONTEND noninteractive

# Proxy configuration (if you are building from behind a proxy)
# Next release of docker 1.9.0 should allow you to configure these by passing build-time arguments
# More info: https://github.com/docker/docker/issues/14634

#ENV http_proxy 'http://user:password@proxy-host:proxy-port'
#ENV https_proxy 'http://user:password@proxy-host:proxy-port'
#ENV HTTP_PROXY 'http://user:password@proxy-host:proxy-port'
#ENV HTTPS_PROXY 'http://user:password@proxy-host:proxy-port'

ENV JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true -Djavax.xml.accessExternalSchema=http -Xms1024m -Xmx1024m -XX:+UseConcMarkSweepGC -server"

ENV AUTHZFORCE_SERVER_VERSION="${project.version}"
ENV AUTHZFORCE_SERVER_DOWNLOAD_URL="http://repo1.maven.org/maven2/org/ow2/authzforce/authzforce-ce-server-dist/$AUTHZFORCE_SERVER_VERSION/authzforce-ce-server-dist-$AUTHZFORCE_SERVER_VERSION.deb"

# Download and install Authzforce Server (service starts automatically)
# Where there is a command with a pipe, we need to put in between quotes and make it an argument to bash -c command
RUN apt-get update --assume-yes -qq && \
 apt-get install --assume-yes -qq \
        locales-all \ 
        locales \
        less \
        apt-utils \ 
        debconf-utils \
        gdebi \
        curl && \
 rm -rf /var/lib/apt/lists/* 
 
RUN locale-gen en_US en_US.UTF-8
RUN dpkg-reconfigure locales
ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US:en 
ENV LC_ALL en_US.UTF-8 

RUN curl --silent --output authzforce-ce-server.deb --location $AUTHZFORCE_SERVER_DOWNLOAD_URL && \
 dpkg --extract authzforce-ce-server.deb /root/authzforce/ && \
 mv /root/authzforce/etc/tomcat8/Catalina /usr/local/tomcat/conf/ && \
 mv /root/authzforce/opt/* /opt/ && \
 rm -rf /opt/authzforce-ce-server/data/domains/* && \
 rm -rf /root/authzforce && \
 rm -f authzforce-ce-server.deb
CMD ["catalina.sh", "run"]

### Exposed ports
# - App server
EXPOSE 8080
