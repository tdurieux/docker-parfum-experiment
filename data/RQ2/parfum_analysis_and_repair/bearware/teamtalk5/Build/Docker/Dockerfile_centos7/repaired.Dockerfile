FROM centos:7

LABEL Description="TeamTalk for CentOS 7"

RUN yum -y --enablerepo=extras install epel-release && rm -rf /var/cache/yum
RUN yum -y update
RUN yum install -y make libtool gcc-c++ cmake3 git ninja-build openssl-devel doxygen && rm -rf /var/cache/yum
RUN ln -s /bin/cmake3 /bin/cmake
