FROM centos:6

RUN yum update -y && yum install git -y && rm -rf /var/cache/yum

COPY ./install_pkg.sh /

