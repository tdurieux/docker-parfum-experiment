#distri we want
FROM centos:7

#workdir
WORKDIR /workdir
ENV IN_DOCKER yes

## RHEL/CentOS 7 64-Bit ##
RUN yum update
RUN yum install -y wget && rm -rf /var/cache/yum
RUN wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -ivh epel-release-latest-7.noarch.rpm

#get list of packages
RUN yum update -y

#install deps
RUN yum install -y make gcc gcc-c++ cmake git && rm -rf /var/cache/yum
RUN yum install -y libunwind-devel elfutils-devel && rm -rf /var/cache/yum
RUN yum install -y rpm-build rpmdevtools && rm -rf /var/cache/yum
#RUN yum install -y qt5-qtwebkit-devel
RUN yum install -y --enable-repo epel qt5-qtwebkit-devel && rm -rf /var/cache/yum
