FROM centos:7

RUN yum update -y && yum install rpm-build make python-setuptools -y && rm -rf /var/cache/yum

COPY ./build-rpms.sh /
