#######################################################################
#                                                                     #
# Creates a base CentOS image with Nexus							  #
#                                                                     #
#######################################################################

# Use the centos base image
FROM centos:centos6
MAINTAINER Siamak Sadeghianfar <ssadeghi@redhat.com>


USER root
# Update the system
RUN yum -y update;yum clean all

##########################################################
# Install Java JDK, SSH and other useful cmdline utilities
##########################################################
RUN yum -y install java-1.7.0-openjdk-devel which telnet unzip openssh-server sudo openssh-clients iputils iproute httpd-tools wget tar; rm -rf /var/cache/yum yum clean all
ENV JAVA_HOME /usr/lib/jvm/jre

##########################################################
# Install Nexus
##########################################################
RUN mkdir -p /opt/sonatype-nexus /opt/sonatype-work
RUN wget -O /tmp/nexus-latest-bundle.tar.gz https://www.sonatype.org/downloads/nexus-latest-bundle.tar.gz
RUN tar xzvf /tmp/nexus-latest-bundle.tar.gz -C /opt/sonatype-nexus --strip-components=1 && rm /tmp/nexus-latest-bundle.tar.gz
RUN useradd --user-group --system --home-dir /opt/sonatype-nexus nexus

ADD nexus.xml /opt/sonatype-work/nexus/conf/nexus.xml

RUN chown -R nexus:nexus /opt/sonatype-work /opt/sonatype-nexus

ENV NEXUS_WEBAPP_CONTEXT_PATH /nexus
RUN echo "#!/bin/bash" > /opt/start-nexus.sh
RUN echo "su -c \"/opt/sonatype-nexus/bin/nexus console\" - nexus" >> /opt/start-nexus.sh
RUN chmod +x /opt/start-nexus.sh

CMD ["/opt/start-nexus.sh"]
EXPOSE 8081