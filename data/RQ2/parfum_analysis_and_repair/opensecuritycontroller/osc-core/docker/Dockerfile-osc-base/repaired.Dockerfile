FROM centos:latest

MAINTAINER Arvind Nadendla <arvindn05@gmail.com>

RUN yum update -y && \
yum install -y wget && \
 wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/8u162-b12/0da788060d494f5095bf8624735fa2f1/jre-8u162-linux-x64.rpm && \
yum localinstall -y jre-8u162-linux-x64.rpm && \
rm -rf jre-8u162-linux-x64.rpm && \
yum install -y iproute && \
yum install -y graphviz && \
rm -rf /var/cache/yum

# Set environment variables.
ENV JAVA_HOME /usr/java/jre1.8.0_162

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["bash"]
