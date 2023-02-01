FROM centos

# This is just a temp example...
RUN yum install -y vim wget && rm -rf /var/cache/yum

CMD exit 0
