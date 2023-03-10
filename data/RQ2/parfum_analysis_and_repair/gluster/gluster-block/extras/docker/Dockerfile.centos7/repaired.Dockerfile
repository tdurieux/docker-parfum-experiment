# Dockerfile for testing the build of gluster-block based on centos7

FROM centos:centos7

ENV BUILDDIR=/build
RUN mkdir -p $BUILDDIR
WORKDIR $BUILDDIR

COPY . $BUILDDIR

# prepare the system
RUN true \
 && yum -y update && yum clean all \
 && true
RUN true \
 && yum -y install \
           git autoconf automake gcc libtool make file \
           glusterfs-api-devel libuuid-devel json-c-devel \
 && true && rm -rf /var/cache/yum

# build
RUN true \
 && ./autogen.sh \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-tirpc=no \
 && make \
 && make check \
 && make install \
 && make clean \
 && true

