FROM quay.io/centos/centos:stream8

RUN yum update -y
RUN yum install -y \
    net-tools \
    iproute \
    iputils && rm -rf /var/cache/yum

CMD /bin/bash
