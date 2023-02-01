# Dockerfile - minimal-centos
#
# usage: docker build -t minimal-centos .

FROM centos:7

# build environment
WORKDIR /root/

# update
RUN yum -y update

# editor
RUN yum -y install vim nano && rm -rf /var/cache/yum

# general
RUN yum -y install sudo sshpass && rm -rf /var/cache/yum

# network commands
RUN yum -y install net-tools && rm -rf /var/cache/yum
RUN yum -y install iputils && rm -rf /var/cache/yum
RUN yum -y install bind-utils && rm -rf /var/cache/yum
RUN yum -y install lsof && rm -rf /var/cache/yum
RUN yum -y install curl wget && rm -rf /var/cache/yum

# python
RUN yum -y install python-devel && rm -rf /var/cache/yum
RUN curl -f "https://bootstrap.pypa.io/pip/2.7/get-pip.py" -o /tmp/get-pip.py
RUN python /tmp/get-pip.py

# java
RUN yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel && rm -rf /var/cache/yum
# maven (3.0.5-17)
RUN yum -y install maven && rm -rf /var/cache/yum

# supervisord
RUN pip install --no-cache-dir supervisor==3.3.3
RUN mkdir -p /var/log/supervisord/
