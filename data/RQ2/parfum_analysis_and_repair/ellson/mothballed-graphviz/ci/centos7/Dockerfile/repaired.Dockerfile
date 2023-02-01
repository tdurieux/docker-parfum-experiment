FROM centos:7

# Install Development tools
RUN yum -y groupinstall 'Development Tools'

# Instal build utilities
RUN yum -y install libtool-ltdl-devel ghostscript swig ksh tcl cmake && rm -rf /var/cache/yum

# Install dependencies
RUN yum -y install gd gd-devel qt-devel libpango1.0-dev && rm -rf /var/cache/yum
