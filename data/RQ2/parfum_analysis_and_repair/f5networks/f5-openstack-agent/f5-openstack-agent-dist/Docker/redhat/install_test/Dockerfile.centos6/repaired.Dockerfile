FROM centos:6

RUN yum update -y && yum install rpm-build make python-setuptools python-requests -y && rm -rf /var/cache/yum

COPY ./install_pkg.sh /

