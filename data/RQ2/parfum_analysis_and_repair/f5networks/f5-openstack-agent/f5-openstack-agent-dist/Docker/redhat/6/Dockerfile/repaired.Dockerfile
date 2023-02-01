FROM centos:6

RUN yum update -y && yum install rpm-build make tar python-setuptools git epel-release -y && rm -rf /var/cache/yum
RUN yum update -y && yum install python-pip -y && rm -rf /var/cache/yum
RUN pip install --no-cache-dir argparse

COPY ./build-rpms.sh /
