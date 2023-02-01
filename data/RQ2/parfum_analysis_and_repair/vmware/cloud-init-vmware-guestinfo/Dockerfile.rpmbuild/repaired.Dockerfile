FROM centos:7
RUN yum install -y rpm-build && rm -rf /var/cache/yum
