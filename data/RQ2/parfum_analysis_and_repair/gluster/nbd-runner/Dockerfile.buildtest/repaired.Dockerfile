# Dockerfile for testing the build of nbd-runner

FROM fedora:30

ENV BUILDDIR=/build
RUN mkdir -p $BUILDDIR
WORKDIR $BUILDDIR

COPY . $BUILDDIR

# prepare the system
RUN true \
 && dnf -y install \
           git autoconf automake gcc libtool make file \
           libevent-devel glib2-devel libnl3-devel     \
           glusterfs-api-devel kmod-devel json-c-devel \
           libtirpc-devel rpcgen clang libuv-devel     \
           libcurl-devel \
 && true

# build
RUN true \
 && ./autogen.sh \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-travis=yes --with-clang=yes \
 && make \
 && make check \
 && make install \
 && make clean \
 && true

