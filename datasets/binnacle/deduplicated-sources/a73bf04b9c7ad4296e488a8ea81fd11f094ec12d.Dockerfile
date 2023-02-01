# © Copyright IBM Corporation 2017, 2019.
# LICENSE: Apache License, Version 2.0 (http://www.apache.org/licenses/LICENSE-2.0)

	################ Dockerfile for Jenkins server version ###################
#
# This Dockerfile builds a basic installation of Jenkins server.
#
# Jenkins is an open source continuous integration tool written in Java. The project was forked from Hudson after a dispute with Oracle.
# Jenkins provides continuous integration services for software development.
# It is a server-based system running in a servlet container such as Apache Tomcat.
#
# To build this image, from the directory containing this Dockerfile
# (assuming that the file is named Dockerfile):
# docker build -t <image_name> .
#
# To Start Jenkins server create a container from the created image and
# expose port 8080.
# docker run --name <container_name> -p <port_number>:8080 -d <image_name>
# To see the Jenkins UI, go to http://<hostname>:<port_number>/ on the web browser.
#
##################################################################################

# Base Image
FROM s390x/ubuntu:16.04
# The author
LABEL maintainer="LoZ Open Source Ecosystem (https://www.ibm.com/developerworks/community/groups/community/lozopensource)"
# Set Environment Variables
ENV JAVA_HOME=/opt/ibm/java
ENV PATH=$JAVA_HOME/bin:$PATH
# Install dependencies
RUN apt-get update &&  apt-get install -y wget \
# Download IBMJDK
&& wget http://public.dhe.ibm.com/ibmdl/export/pub/systems/cloud/runtimes/java/8.0.5.30/linux/s390x/ibm-java-s390x-sdk-8.0-5.30.bin \
&& wget https://raw.githubusercontent.com/zos-spark/scala-workbench/master/files/installer.properties.java \
&& tail -n +3 installer.properties.java | tee installer.properties \
&& chmod +x ibm-java-s390x-sdk-8.0-5.30.bin \
&& ./ibm-java-s390x-sdk-8.0-5.30.bin -r installer.properties \
# Install Jenkins
&& wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war \
# Clean up Cache data and unused dependencies
&& apt-get remove -y wget \
&& apt-get autoremove -y && apt-get clean \
EXPOSE 8080
CMD java -jar jenkins.war && tail -f /var/log/jenkins/jenkins.log
# End of Dockerfile
