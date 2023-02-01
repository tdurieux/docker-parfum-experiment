FROM centos:6

RUN yum install iproute epel-release sudo -y && rm -rf /var/cache/yum
