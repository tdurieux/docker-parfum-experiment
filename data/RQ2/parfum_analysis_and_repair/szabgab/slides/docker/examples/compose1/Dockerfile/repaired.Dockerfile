FROM centos:7
RUN yum install -y less vim which && rm -rf /var/cache/yum
WORKDIR /opt
