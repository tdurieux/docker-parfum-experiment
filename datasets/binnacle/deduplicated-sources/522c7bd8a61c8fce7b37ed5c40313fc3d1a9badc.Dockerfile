FROM ubuntu:14.04

MAINTAINER xianlubird <xianlubird@gmail.com>

# Setup mesosphere repository
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && \
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]') && \
CODENAME=$(lsb_release -cs) && \
echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | sudo tee /etc/apt/sources.list.d/mesosphere.list && \
sudo apt-get -y update

# Install vim and curl for programming and test
RUN sudo apt-get -y install vim curl

# http://docs.docker.com/installation/ubuntulinux/
RUN curl -fLsS https://get.docker.com/ | sh

# Install mesos and marathon (The Mesos package will automatically pull in the ZooKeeper package as a dependency)
RUN sudo apt-get -y install mesos marathon

#Update slave configuration to specify the use of the Docker containerizer
RUN echo 'docker,mesos' > /etc/mesos-slave/containerizers
RUN echo '5mins' > /etc/mesos-slave/executor_registration_timeout

USER root

WORKDIR /root

EXPOSE 8080 5050

ADD hello.json /root/hello.json

# Add script for start the mesos/marathon cluster
ADD start-cluster.sh /root/start-cluster.sh
RUN chmod +x /root/start-cluster.sh
CMD '/root/start-cluster.sh'; bash

