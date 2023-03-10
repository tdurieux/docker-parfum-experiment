FROM centos:7
ENV VERSION 18.2.1
ENV RELEASE 1
MAINTAINER Tiffany Meyer<tiffanym@ucar.edu>

USER root

RUN yum update yum -y

RUN yum groupinstall "Development tools" -y
RUN yum install epel-release -y && rm -rf /var/cache/yum
RUN yum clean all -y

ENV systemDeps="wget rsync git net-tools gzip libtool"
ENV rpmDeps="gcc gcc-c++ glibc-devel rpm-build readline-devel createrepo"
ENV qpidDeps="boost-devel cmake make ruby libuuid-devel"
ENV pythonDeps="tk-devel tcl-devel atlas-devel compat-libf2c-34 libgfortran geos-devel libpng-devel freetype"
ENV awipsDeps="netcdf netcdf-devel hdf5-devel lzo-devel bzip2-devel qt-devel xz-devel"
ENV httpDeps="autoconf findutils libselinux-devel libxml2-devel lua-devel openldap-devel openssl-devel pcre-devel pkgconfig perl zlib-devel apr-util-devel apr-devel"

RUN yum install $systemDeps $rpmDeps $qpidDeps $pythonDeps $awipsDeps $httpDeps -y && rm -rf /var/cache/yum

ENTRYPOINT ["/bin/bash"]
