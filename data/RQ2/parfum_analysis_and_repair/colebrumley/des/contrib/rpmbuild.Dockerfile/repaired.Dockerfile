FROM        centos:7
RUN yum -y install rpm-build python-setuptools && rm -rf /var/cache/yum
ENTRYPOINT  ["/usr/bin/rpmbuild","--rebuild"]
