FROM centos:centos6
MAINTAINER Sebastien Le Digabel "sledigabel@gmail.com"

RUN yum update -y
RUN yum install -y rpmdevtools mock && rm -rf /var/cache/yum

RUN cd /root && rpmdev-setuptree
ADD SOURCES/* /root/rpmbuild/SOURCES/
ADD SPECS/* /root/rpmbuild/SPECS/
RUN ln -s /root/rpmbuild/RPMS /RPMS

VOLUME ["/RPMS"]

CMD set -x && cd /root && spectool -g -R rpmbuild/SPECS/consul.spec && rpmbuild -ba rpmbuild/SPECS/consul.spec
