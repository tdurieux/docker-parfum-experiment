FROM centos:6

RUN yum update -y && yum install rpm-build make tar python-setuptools -y && rm -rf /var/cache/yum

COPY ./build-rpms.sh /
