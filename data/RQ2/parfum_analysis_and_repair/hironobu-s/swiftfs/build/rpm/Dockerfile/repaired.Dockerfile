FROM centos:6

RUN yum update -y
RUN yum install -y rpm-build rpmdevtools yum-utils && rm -rf /var/cache/yum
VOLUME /root/rpmbuild

WORKDIR /root/rpmbuild
CMD rpmbuild -ba /root/rpmbuild/SPECS/swiftfs.json.spec
