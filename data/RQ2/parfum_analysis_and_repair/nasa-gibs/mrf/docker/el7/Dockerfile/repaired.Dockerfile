FROM centos:7

COPY rpms/gibs-gdal-*.el7.*.rpm /rpms/

RUN yum install -y epel-release && yum clean all && rm -rf /var/cache/yum
RUN yum install -y /rpms/gibs-gdal-*.el7.*.rpm && rm -rf /var/cache/yum
