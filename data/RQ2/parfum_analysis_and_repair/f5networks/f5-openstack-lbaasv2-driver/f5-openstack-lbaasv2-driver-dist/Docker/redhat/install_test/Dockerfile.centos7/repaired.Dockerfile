FROM centos:7

RUN yum update -y && yum install git -y && rm -rf /var/cache/yum

COPY ./install_pkg.sh /
