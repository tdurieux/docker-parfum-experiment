FROM centos:7
RUN yum install -y less vim which net-tools && rm -rf /var/cache/yum
