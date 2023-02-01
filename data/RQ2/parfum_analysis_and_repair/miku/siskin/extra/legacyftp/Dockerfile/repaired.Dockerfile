FROM centos:centos7.9.2009
RUN yum install -y lftp && rm -rf /var/cache/yum
ENTRYPOINT ["/usr/bin/lftp"]
