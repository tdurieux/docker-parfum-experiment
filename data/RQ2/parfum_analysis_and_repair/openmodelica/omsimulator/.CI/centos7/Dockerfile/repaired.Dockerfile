FROM centos:7

RUN yum -y install epel-release && rm -rf /var/cache/yum

RUN yum -y install libtool automake gcc-c++ libstdc++-static boost-devel git make cmake3 readline-devel lua-devel && rm -rf /var/cache/yum
