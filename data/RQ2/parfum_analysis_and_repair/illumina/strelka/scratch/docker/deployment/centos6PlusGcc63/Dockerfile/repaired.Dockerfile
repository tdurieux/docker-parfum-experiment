#
# This is a simple image used to assist with deploying portable
# binaries, by allowing us to build in a virtual centos 6
# environment.
#
# At present we simply add all of the project's build requirements onto
# the centos6 base image.
#

FROM centos:6

# add standard centos6 packages - adding cmake here for extra speed even though strelka could bootstrap this
RUN yum install -y bzip2 gcc gcc-c++ tar wget zlib-devel cmake git && rm -rf /var/cache/yum

RUN yum install -y centos-release-scl && rm -rf /var/cache/yum
RUN yum install -y devtoolset-6-gcc devtoolset-6-gcc-c++ && rm -rf /var/cache/yum

# Prior to build configuration, set CC/CXX to new gcc version:
ENV CC /opt/rh/devtoolset-6/root/usr/bin/gcc
ENV CXX /opt/rh/devtoolset-6/root/usr/bin/g++

