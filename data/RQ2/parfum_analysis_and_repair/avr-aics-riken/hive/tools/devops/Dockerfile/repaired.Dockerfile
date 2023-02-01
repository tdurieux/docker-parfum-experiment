FROM centos:6
MAINTAINER Syoyo Fujita <syoyo@lighttransport.com>

RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum -y update

RUN yum install -y git gcc g++ && rm -rf /var/cache/yum
RUN yum install -y autoconf automake libtool && rm -rf /var/cache/yum

RUN yum install -y openmpi && rm -rf /var/cache/yum
RUN yum install -y hdf5-devel hdf5-openmpi-devel && rm -rf /var/cache/yum
