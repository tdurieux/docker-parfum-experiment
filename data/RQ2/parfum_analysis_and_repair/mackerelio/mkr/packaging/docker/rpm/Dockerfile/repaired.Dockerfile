FROM centos:centos7

RUN yum update -y && yum install -y rpmdevtools && rm -rf /var/cache/yum

ADD rpmmacros /root/.rpmmacros

WORKDIR /rpm
ENTRYPOINT ["/usr/bin/rpmbuild"]
