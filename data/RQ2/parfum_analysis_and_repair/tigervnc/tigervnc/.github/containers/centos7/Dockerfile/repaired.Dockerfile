FROM centos:7

RUN yum -y groupinstall 'Development Tools'
RUN yum -y install centos-packager && rm -rf /var/cache/yum

RUN yum -y install sudo && rm -rf /var/cache/yum

RUN useradd -s /bin/bash -m rpm
RUN echo >> /etc/sudoers
RUN echo "rpm ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER rpm
WORKDIR /home/rpm
