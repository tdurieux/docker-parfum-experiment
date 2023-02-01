FROM quay.io/centos/centos:stream8

RUN yum install -y createrepo rpm-sign pinentry && rm -rf /var/cache/yum
