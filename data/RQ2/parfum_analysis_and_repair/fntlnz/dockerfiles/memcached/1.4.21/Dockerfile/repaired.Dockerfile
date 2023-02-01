# Memcached
# @version 1.4.21
# @author Lorenzo Fontana <fontanalorenzo@me.com>
FROM centos:centos7

MAINTAINER Lorenzo Fontana, fontanalorenzo@me.com

# Prerequisites
RUN yum install tar wget make gcc libevent-devel -y && rm -rf /var/cache/yum

WORKDIR /tmp
RUN wget -nv -O - https://www.memcached.org/files/memcached-1.4.21.tar.gz | tar zx
RUN mv memcached-1.4.21 memcached
WORKDIR memcached
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local/memcached
RUN make
RUN make install
RUN ln -s /usr/local/memcached/bin/* /usr/local/bin/memcached
RUN useradd memcache

WORKDIR /

EXPOSE 11211

ENTRYPOINT ["/usr/local/bin/memcached"]
CMD ["-u", "memcache", "-v"]
