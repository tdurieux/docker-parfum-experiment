from centos
RUN yum -y update && yum install -y createrepo && rm -rf /var/cache/yum
CMD createrepo
