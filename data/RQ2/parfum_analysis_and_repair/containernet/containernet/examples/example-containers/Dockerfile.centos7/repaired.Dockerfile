FROM centos:7
MAINTAINER manuel.peuster@uni-paderborn.de

RUN yum update -y
RUN yum install -y \
    net-tools \
    iproute \
    iputils-ping && rm -rf /var/cache/yum

CMD /bin/bash
